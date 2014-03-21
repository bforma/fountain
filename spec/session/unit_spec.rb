require 'spec_helper'
require 'domain/fixtures'

module Fountain::Session
  describe Unit do
    before do
      UnitStack.rollback_all
    end

    after do
      if UnitStack.active?
        UnitStack.clear_all
        fail 'Unit stack not properly cleared'
      end
    end

    describe '#commit' do
      it 'saves registered aggregates' do
        aggregate = InventoryItem.new(123)
        callback = double
        event_bus = double.as_null_object

        subject.register_aggregate(aggregate, event_bus, callback)

        expect(callback).to receive(:call).with(aggregate)

        subject.start
        subject.commit
      end

      it 'publishes aggregate events' do
        aggregate = InventoryItem.new(123)
        aggregate.check_in(10)

        callback = double.as_null_object
        event_bus = double

        subject.register_aggregate(aggregate, event_bus, callback)

        expect(event_bus).to receive(:publish).with(*aggregate.uncommitted_events)

        subject.start
        subject.commit
      end

      it 'rolls back if listener fails during commit prep' do
        listener = double

        subject.register_listener(listener)
        subject.start

        error = RuntimeError.new
        expect(listener).to receive(:on_prepare_commit).ordered do
          raise error
        end

        expect(listener).to receive(:on_rollback).with(subject, error).ordered
        expect(listener).to receive(:on_cleanup).with(subject).ordered

        expect {
          subject.commit
        }.to raise_error(error)
      end

      it 'rolls back if aggregate callback fails' do
        listener = double

        error = RuntimeError.new
        aggregate = double(id: 123).as_null_object
        callback = double

        subject.register_listener(listener)
        subject.start

        subject.register_aggregate(aggregate, Object.new, callback)

        expect(listener).to receive(:on_prepare_commit).ordered
        expect(callback).to receive(:call).with(aggregate).ordered do
          raise error
        end
        expect(listener).to receive(:on_rollback).with(subject, error).ordered
        expect(listener).to receive(:on_cleanup).with(subject).ordered

        expect {
          subject.commit
        }.to raise_error(error)
      end

      it 'rolls back if event publication fails' do
        listener = double

        aggregate = InventoryItem.new(123)
        callback = double
        error = RuntimeError.new
        event_bus = double

        subject.register_listener(listener)
        subject.start

        allow(listener).to receive(:on_event_registered) do |_, event|
          event
        end

        subject.register_aggregate(aggregate, event_bus, callback)

        expect(listener).to receive(:on_prepare_commit).ordered
        expect(callback).to receive(:call).with(aggregate).ordered
        expect(event_bus).to receive(:publish).ordered do
          raise error
        end
        expect(listener).to receive(:on_rollback).with(subject, error).ordered
        expect(listener).to receive(:on_cleanup).with(subject).ordered

        expect {
          subject.commit
        }.to raise_error(error)
      end

      it 'raises an error if unit was not started' do
        expect {
          subject.commit
        }.to raise_error(Fountain::InvalidStateError)
      end
    end

    describe '#start' do
      it 'raises an error when unit already active' do
        subject.start

        expect {
          subject.start
        }.to raise_error(Fountain::InvalidStateError)

        subject.commit
      end
    end

    context 'when nesting' do
      it 'rolls back inner units when outer unit is rolled back' do
        outer = Unit.start
        inner = Unit.start

        listener = double
        inner.register_listener(listener)

        expect(listener).to receive(:on_prepare_commit)

        inner.commit

        expect(listener).to receive(:on_rollback)
        expect(listener).to receive(:on_cleanup)

        outer.rollback
      end

      it 'delays commit until outer unit committed' do
        outer = Unit.start
        inner = Unit.start

        listener = double
        inner.register_listener(listener)

        expect(listener).to receive(:on_prepare_commit).ordered
        inner.commit

        expect(listener).to receive(:after_commit).ordered
        expect(listener).to receive(:on_cleanup).ordered
        outer.commit
      end

      it 'delays inner unit cleanup from commit until after outer unit commit' do
        outer = Unit.start
        inner = Unit.start

        outer_listener = double
        inner_listener = double

        outer.register_listener(outer_listener)
        inner.register_listener(inner_listener)

        expect(inner_listener).to receive(:on_prepare_commit).ordered

        inner.commit

        expect(outer_listener).to receive(:on_prepare_commit).ordered
        expect(inner_listener).to receive(:after_commit).ordered
        expect(outer_listener).to receive(:after_commit).ordered
        expect(inner_listener).to receive(:on_cleanup).ordered
        expect(outer_listener).to receive(:on_cleanup).ordered

        outer.commit
      end

      it 'delays inner unit cleanup from rollback until after outer unit commit' do
        outer = Unit.start
        inner = Unit.start

        outer_listener = double
        inner_listener = double

        outer.register_listener(outer_listener)
        inner.register_listener(inner_listener)

        expect(inner_listener).to receive(:on_rollback).ordered

        inner.rollback

        expect(outer_listener).to receive(:on_prepare_commit).ordered
        expect(outer_listener).to receive(:after_commit).ordered
        expect(inner_listener).to receive(:on_cleanup).ordered
        expect(outer_listener).to receive(:on_cleanup).ordered

        outer.commit
      end

      it 'delays inner unit cleanup from commit until after outer unit rollback' do
        outer = Unit.start
        inner = Unit.start

        outer_listener = double
        inner_listener = double

        outer.register_listener(outer_listener)
        inner.register_listener(inner_listener)

        expect(inner_listener).to receive(:on_prepare_commit).ordered

        inner.commit

        expect(inner_listener).to receive(:on_rollback).ordered
        expect(outer_listener).to receive(:on_rollback).ordered
        expect(inner_listener).to receive(:on_cleanup).ordered
        expect(outer_listener).to receive(:on_cleanup).ordered

        outer.rollback
      end
    end

    it 'notifies listeners in correct order during transactional commit' do
      listener = double
      tx_manager = double
      tx = Object.new

      expect(tx_manager).to receive(:start).and_return(tx).ordered

      unit = Unit.start(tx_manager)
      unit.register_listener(listener)

      expect(listener).to receive(:on_prepare_commit).with(unit, anything, anything).ordered
      expect(listener).to receive(:on_prepare_transaction_commit).with(unit, tx).ordered
      expect(tx_manager).to receive(:commit).with(tx).ordered
      expect(listener).to receive(:after_commit).with(unit).ordered
      expect(listener).to receive(:on_cleanup).with(unit).ordered

      unit.commit
    end

    it 'notifies listeners in correct order during commit' do
      listener = double

      unit = Unit.start
      unit.register_listener(listener)

      expect(listener).to receive(:on_prepare_commit).with(unit, anything, anything).ordered
      expect(listener).to receive(:after_commit).with(unit).ordered
      expect(listener).to receive(:on_cleanup).with(unit).ordered

      unit.commit
    end

    it 'notifies listeners in correct order during transactional rollback' do
      listener = double
      tx_manager = double
      tx = Object.new
      error = RuntimeError.new

      expect(tx_manager).to receive(:start).and_return(tx).ordered

      unit = Unit.start(tx_manager)
      unit.register_listener(listener)

      expect(tx_manager).to receive(:rollback).with(tx).ordered
      expect(listener).to receive(:on_rollback).with(unit, error).ordered
      expect(listener).to receive(:on_cleanup).with(unit).ordered

      unit.rollback(error)
    end

    it 'notifies listeners in correct order during rollback' do
      listener = double
      error = RuntimeError.new

      unit = Unit.start
      unit.register_listener(listener)

      expect(listener).to receive(:on_rollback).with(unit, error).ordered
      expect(listener).to receive(:on_cleanup).with(unit).ordered

      unit.rollback(error)
    end

    it 'manages resource inheritance' do
      outer = Unit.start
      outer.attach_resource(:not_inherited, :resource)
      outer.attach_resource(:inherited, :resource, true)

      outer.attach_resource(:inheritance_overwritten, :resource, true)
      outer.attach_resource(:inheritance_overwritten, :resource)

      outer.attach_resource(:inherited_after_all, :resource)
      outer.attach_resource(:inherited_after_all, :resource, true)

      inner = Unit.start
      expect(inner.resource(:inherited)).to_not be_nil
      expect(inner.resource(:inherited_after_all)).to_not be_nil
      expect(inner.resource(:not_inherited)).to be_nil
      expect(inner.resource(:inheritance_overwritten)).to be_nil

      inner.commit
      outer.commit
    end

    it 'processes aggregate events using listeners' do
      aggregate = InventoryItem.new(123)
      event_bus = double
      callback = double.as_null_object

      headers = { user_id: 123 }

      listener = double.as_null_object

      subject.register_listener(listener)

      expect(listener).to receive(:on_event_registered) do |_, event|
        event.with_headers(headers)
      end

      subject.register_aggregate(aggregate, event_bus, callback)
      subject.start

      expect(event_bus).to receive(:publish) do |event|
        expect(event.headers).to eql(headers)
      end

      subject.commit
    end
  end
end
