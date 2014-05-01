class Player
  REST_HEALTH = 15   
  RUN_HEALTH = 7 
  MAX_DISTANCE = 4  
   ## These throw the following warning in Epic Mode - /root/rubywarrior/hyber-beginner/player.rb:2: warning: already initialized constant REST_HEALTH as Epic Mode loops through scenarios.  Not fatal.  Look into a fix.
   
  def play_turn(warrior)
    @last_known_health ||= warrior.health ##replaces warrior.health unless @last_known_health.
    @direction ||= :forward
    feel_space = warrior.feel @direction
    ##glance = warrior.look @direction   Deprecated into clear_shot? function, below.
    
    if clear_shot? warrior
      warrior.shoot!
    elsif feel_space.empty?
      if should_flee? warrior
        @direction = :backward
        warrior.walk! @direction
      elsif should_rest? warrior
        warrior.rest!
      else
        warrior.walk! @direction
      end
    elsif feel_space.captive?
      warrior.rescue! @direction
    elsif feel_space.wall?
      @direction = :forward
      warrior.pivot!
    else
      warrior.attack! #@direction.  Deprecated.  No longer necessary.
    end
    
    @last_known_health = warrior.health
  end
 
  private
  
    def clear_shot? warrior
      glance = warrior.look @direction
      distance_to_enemy = glance.index { |space| space.enemy? == true } || MAX_DISTANCE
      distance_to_captive = glance.index { |space| space.captive? == true } || MAX_DISTANCE
      distance_to_enemy < distance_to_captive
      safe?(warrior) && distance_to_enemy < distance_to_captive
    end
    
    def should_flee? warrior
      damaged = warrior.health < RUN_HEALTH
      !safe?(warrior) && damaged 
    end
  
    def should_rest? warrior
      damaged = warrior.health < REST_HEALTH
      safe?(warrior) && damaged
    end
  
    def safe? warrior
      warrior.health >= @last_known_health
    end
end

=begin
Move list
===============
warrior.feel
warrior.health
warrior.look
warrior.rest!
warrior.attack!
warrior.walk!
warrior.shoot!
warrior.pivot!
=end
