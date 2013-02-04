require_relative 'helper'

class TestClock < Sidetiq::TestCase
  class FakeWorker;
  end

  def test_delegates_to_instance
    Sidetiq::Clock.instance.expects(:foo).once
    Sidetiq::Clock.foo
  end

  def test_start_stop
    refute clock.ticking?
    assert_nil clock.thread

    clock.start!
    Thread.pass
    sleep 0.01

    assert clock.ticking?
    assert_kind_of Thread, clock.thread

    clock.stop!
    Thread.pass
    sleep 0.01

    refute clock.ticking?
    refute clock.thread.alive?
  end

  def test_gettime_seconds
    assert_equal clock.gettime.tv_sec, Time.now.tv_sec
  end

  def test_gettime_nsec
    refute_nil clock.gettime.tv_nsec
  end

  def test_gettime_utc
    refute clock.gettime.utc?
    Sidetiq.config.utc = true
    assert clock.gettime.utc?
    Sidetiq.config.utc = false
  end

  def test_enqueues_jobs_by_schedule
    schedule = Sidetiq::Schedule.new(Sidetiq::Clock::START_TIME)
    schedule.daily

    clock.stubs(:schedules).returns(FakeWorker => schedule)

    FakeWorker.expects(:perform_at).times(10)

    10.times do |i|
      clock.stubs(:gettime).returns(Time.local(2011, 1, i + 1, 1))
      clock.tick
    end

    clock.stubs(:gettime).returns(Time.local(2011, 1, 10, 2))
    clock.tick
    clock.tick
    clock.tick
  end
end

