require_relative 'iat'
require 'haid'

class Squirrel
  def initialize name
    @name            = name
    @genus           = 'Saber-Toothed Squirrel'
    @life            = 9           #  9 lifes like a cat  
    @mood            = 5           #  The mood is cheerful  
    @satiety         = 10          #  He is not hungry 
    @thirst          = 7           #  He is not tormented by thirst
    @weariness       = 0           #  He is not tired
    @asleep          = false       #  He is awake
    @irritability    = 3           #  He's annoyed a little because he doesn't have an acorn
    @health          = 10          #  He is healthy
    @big_acorn       = 0           #  He doesn't have the Big Acorn
    @last_feed_time  = Time.now()  #  He has just been fed
    @last_drink_time = Time.now()  #  He just drank some water
    @last_rest_time  = Time.now()  #  He just rested
    @fin             = ''          #  menu cycle end marker 
  end
       
  def give_food
    p "You feed #{@name}"
    if @satiety >= 8
      p "#{@name} doesn't want your stupid small nuts, he wants the Big Acorn!"
      @irritability += 1       
      passage_of_time if @irritability >10
    else
      @satiety += 3
      @last_feed_time = Time.now()  
    end
    Haid.html_gen(html,  bypass_html: true)
    info
  end
      
  def give_water
    p "You give #{@name} some water"
    if @thirst >= 7
      p "#{@name} doesn't want to drink water! He wants the Big Acorn or some gin or whiskey at least :)"
      @irritability += 1
      passage_of_time if @irritability >10
    else
      @thirst += 1
      @last_drink_time = Time.now()  
    end
    Haid.html_gen(html,  bypass_html: true)
    info
  end
      
  def put_to_cave
    p "You put #{@name} to sleep in the cave"
    if @big_acorn == 1 && @weariness > 5
      @asleep       = true
      @irritability = 0
      @weariness   -= 1
      3.times do
        if @asleep
          passage_of_time
        end
        if @asleep
          p "#{@name} drops an acorn from his hands"
          @last_rest_time  = Time.now()
        end
      end
      if @asleep
        @asleep       = false
        @mood         -= 1
        @irritability += 1
        passage_of_time if @irritability >10 || @mood < 1
        p "#{@name} jumps out of the cave in search of an acorn"
      end
    else
      if @big_acorn < 1
        p "#{@name} won't fall asleep without an acorn"
      else
        p "#{@name} doesn't want to sleep"
      end
      @asleep = false
      @mood  -= 1
      passage_of_time if @mood < 1
    end
    Haid.html_gen(html,  bypass_html: true)
    info
  end
      
  def give_cure
    p "You heal #{@name}"
    if @health >= 10 
      p "#{@name} is perfectly healthy and wants the Big Acorn not medicine!"
      @irritability += 1
      passage_of_time if @irritability >10
    else
      @health += 1  
    end
    Haid.html_gen(html,  bypass_html: true)
    info
  end
      
  def give_acorn
    p "You give #{@name} the Big Acorn"
    @big_acorn    += 1
    @irritability = 0
    @mood         = 5
    p "Joyful #{@name} runs to hide the acorn"
    Haid.html_gen(html,  bypass_html: true)
    incident
  end  

  private
      
  def moody?   # if Scrat is sad
    @mood < 1
  end

  def hungry?  # if Scrat is hungry
    @satiety <= 3
  end
      
  def thirsted?  # if Scrat feels thirsty
    @thirst <= 2
  end

  def angry?  # if Scrat is angry
    @irritability > 10
  end

  def sick?  # if Scrat is sick
    @health < 1
  end

  def two_acorn?  # if Scrat has 2 acorns at once
    @big_acorn > 1
  end  

  def incident  # Scrat has an adventure when he tries to hide an acorn
    @big_acorn > 0 && @asleep = false && @weariness < 7
    inc = rand(14)
    case inc
    when 0, 2, 4, 8, 10, 12, 13
      p "#{@name} tries to hide the acorn, but he can't"
      @irritability += 1
      @mood         -= 1
      @weariness    += 1
      passage_of_time 
    when 1
      p "#{@name} got caught in an avalanche"
      @health       -= 3
      @big_acorn     = 0
      @mood         -= 2
      @irritability += 3
      passage_of_time
    when 3
      p "#{@name} fell through the ice"
      @health       -= 2
      @big_acorn     = 0
      @mood         -= 2
      @irritability += 2
      passage_of_time
    when 5
      p "#{@name} fell off the cliff"
      @health       -= 4
      @big_acorn     = 0
      @mood         -= 2
      @irritability += 3
      passage_of_time
    when 7
      p "#{@name} was struck by lightning"
      @health       -= 5
      @big_acorn     = 0
      @mood         -= 3
      @irritability += 3
      passage_of_time
    when 9
      p "#{@name} Scrat engaged in a battle with piranhas"
      @health       -= 1
      @big_acorn     = 0
      @mood         += 2
      @irritability -= 1
      passage_of_time
    when 11
      p "#{@name} ended up in space"
      @big_acorn    = 0
      @life        -= 1
      @mood         = 5           
      @satiety      = 10          
      @thirst       = 7           
      @weariness    = 0           
      @irritability = 3           
      @health       = 10          
      passage_of_time
    end
  end

  def passage_of_time # some time passes
    if @life < 1
      p "#{@name} has died :((("
      @fin = 'exit'
      exit  #  exit the game  
    end
  
    if @satiety > 0
      if Time.now() - @last_feed_time > 300
        @satiety -= 3 
      end  
    else  #  Scrat is starving!
      if @asleep
        @asleep = false
        p "#{@name} Suddenly wakes up!"
      end
      p "Hungry #{@name} has eaten you!"
      @fin = 'exit'
      exit  #  exit the game
    end
        
    if @thirst > 0
      if Time.now() - @last_drink_time > 180
         @thirst -= 1
      end
    else # Scrat is suffering from thirst
      p "#{@name} has lost 1 life due to thirst!"
      @life   -= 1
      @health  = 10
      @thirst  = 7 
    end

    if @weariness < 10
      if Time.now() - @last_rest_time > 420
         @weariness += 1
      end
    else # Scrat is exhausted
      p "#{@name} has lost 1 life due to exhaustion"
      @life     -= 1
      @health    = 10
      @weariness = 0   
    end
        
    if moody? 
      p "#{@name} has lost 1 life due to sorrow!"
      @life   -= 1
      @health  = 10
      @mood    = 5
    end

    if hungry?
      if @asleep
        @asleep = false
        p "#{@name} wakes up suddenly!"
      end
      p "#{@name} is hungry!"
    end

    if thirsted?
      if @asleep
        @asleep = false
        p "#{@name} wakes up suddenly!"
      end
      p "#{@name} wants to drink!"
    end

    if angry?
      p "An irritated #{@name} has killed you in a state of affect!"
      @fin = 'exit'
      exit  #  exit the game
    end

    if sick?
      p "#{@name} has lost 1 life due to disease"
      @life     -= 1
      @health    = 10
    end
        
    if two_acorn?
      p "#{@name} tries to carry 2 acorns at the same time, loses both"
      @big_acorn     = 0
      @mood         -= 1
      @irritability += 1
    end
    Haid.html_gen(html,  bypass_html: true)
    info
  end
  
  IceAge = Squirrel.new 'Scrat'
end     

