# Exercise 5 Part 1 (Exception Handling)
class MentalState

  def auditable?
    # true if the external service is online, otherwise false
  end

  def audit!
    # Could fail if external service is offline
  end

  def do_work
    # Amazing stuff...
  end

end

def audit_sanity(bedtime_mental_state)
  raise MentalStateError unless bedtime_mental_state.auditable?
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else 
    MorningMentalState.new(:not_ok)
  end
end

if audit_sanity(bedtime_mental_state) == 0
  raise MentalStateError
else
  new_state = audit_sanity(bedtime_mental_state)
end

# Exercise 5 Part 2 (Don't Return Null / Null Object Pattern)
class BedtimeMentalState < MentalState ; end

class MorningMentalState < MentalState ; end

class NullMentalState < MentalState ; end

def audit_sanity(bedtime_mental_state)
  raise ConnectionError.new("External Service is Offline")if  !bedtime_mental_state.auditable?
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else 
    MorningMentalState.new(:not_ok)
  end
end

begin
  new_state = audit_sanity(bedtime_mental_state)
rescue => ConnectionError
  new_state.NullMentalState.new(:not_ok)
end
new_state.do_work

# Exercise 5 Part 3 (Wrapping APIs)

require 'candy_service'

class NotReadyError < StandardError ; end

class MyCandyMachine < CandyMachine

  def initialize
    # do stuff
  end

  def prepare
    # more stuff
  end

  def make!
    raise NotReadyError.new("sadness") if !self.ready?
  end
end

machine = MyCandyMachine.new
machine.prepare

begin
  machine.make!
rescue NotReadyError => e
  puts e.message
end
