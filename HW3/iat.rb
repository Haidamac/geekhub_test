require 'haid'
require 'os'
#require_relative 'htmlgen'

class Squirrel
  attr_reader :name, :life, :health, :mood, :satiety, :thirst, :weariness, :asleep, :irritability, :big_acorn, :last_feed_time, :last_drink_time, :last_rest_time

  def initialize name
    @name            = name
    @genus           = 'Saber-Toothed Squirrel'
    @life            = 9           #  9 lifes like a cat  
    @mood            = 9           #  The mood is cheerful  
    @satiety         = 9          #  He is not hungry 
    @thirst          = 9           #  He is not tormented by thirst
    @weariness       = 0           #  He is not tired
    @asleep          = false       #  He is awake
    @irritability    = 3           #  He's annoyed a little because he doesn't have an acorn
    @health          = 9          #  He is healthy
    @big_acorn       = 0           #  He doesn't have the Big Acorn
    @last_feed_time  = Time.now()  #  He has just been fed
    @last_drink_time = Time.now()  #  He just drank some water
    @last_rest_time  = Time.now()  #  He just rested
    @fin             = ''          #  menu cycle end marker 
  end

  def game
    p 'Hi! I\'m saber-toothed squirrel Scrat from Ice Age! Let\'s go!!!' 
    help
  end
    
  # game help info on the screen  
  def help
    p 'Type \'FEED\' to feed Scrat'
    p 'Type \'WATER\' to water Scrat'
    p 'Type \'BED\' to put Scrat asleep'
    p 'Type \'CURE\' to cure Scrat'
    p 'Type \'ACORN\' for give the Big Acorn to Scrat'
    p 'Type \'HTML\' for watch statistic in browser'
    p 'Type \'QUIT\' for exit from game'
    p 'no matters: upper- or lowercase'
    your_choice  
  end

  # statistics in console
  def info
    puts 'life:         ' + @life.to_s
    puts 'health:       ' + @health.to_s
    puts 'mood:         ' + @mood.to_s
    puts 'satiety:      ' + @satiety.to_s
    puts 'thirst:       ' + @thirst.to_s
    puts 'weariness:    ' + @weariness.to_s
    puts 'irritability: ' + @irritability.to_s
    puts 'acorn:        ' + @big_acorn.to_s
    your_choice
  end

  def your_choice
    until @fin == 'exit'  
      p 'Type - what you want to do?'
      command = gets.chomp.downcase
      case command
      when 'feed'
        give_food
      when 'water'  
        give_water
      when 'bed'  
        put_to_cave
      when 'cure'
        give_cure
      when 'acorn'
        give_acorn
      when 'html'
        htmlgen.generate 
        if OS.windows?
          system("start index.html")  
        else
          system("xdg-open index.html")
        end
      when 'help'
        help
      when 'quit'
        p 'Good bye!!!'
        exit
      else
        p 'Wrong command! Type \"help\" for more information'
      end   
    end
  end 
  
  def give_food
    p "You feed #{@name}"
    if @satiety >= 8
      p "#{@name} doesn't want your stupid small nuts, he wants the Big Acorn!"
      @irritability += 1       
      passage_of_time if @irritability >9
    else
      @satiety += 3
      @last_feed_time = Time.now()  
    end
    htmlgen.generate 
    info
  end
      
  def give_water
    p "You give #{@name} some water"
    if @thirst >= 7
      p "#{@name} doesn't want to drink water! He wants the Big Acorn or some gin or whiskey at least :)"
      @irritability += 1
      passage_of_time if @irritability >9
    else
      @thirst += 1
      @last_drink_time = Time.now()  
    end
    htmlgen.generate 
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
        passage_of_time if @irritability >9 || @mood < 1
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
    htmlgen.generate
    info
  end
      
  def give_cure
    p "You heal #{@name}"
    if @health >= 9 
      p "#{@name} is perfectly healthy and wants the Big Acorn not medicine!"
      @irritability += 1
      passage_of_time if @irritability >9
    else
      @health += 1  
    end
    htmlgen.generate 
    info
  end
      
  def give_acorn
    p "You give #{@name} the Big Acorn"
    @big_acorn    += 1
    @irritability = 0
    @mood         = 9
    p "Joyful #{@name} runs to hide the acorn"
    Htmlgen.generate 
    incident
  end  

  private
      
  def moody?   # if Scrat is sad
    @mood < 1
  end

  def hungry?  # if Scrat is hungry
    @satiety <= 2
  end
      
  def thirsted?  # if Scrat feels thirsty
    @thirst <= 1
  end

  def angry?  # if Scrat is angry
    @irritability > 9
  end

  def sick?  # if Scrat is sick
    @health <= 1
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
      outcome
    when 3
      p "#{@name} fell through the ice"
      outcome
    when 5
      p "#{@name} fell off the cliff"
      outcome
    when 7
      p "#{@name} was struck by lightning"
      outcome
    when 9
      p "#{@name} Scrat engaged in a battle with piranhas"
      outcome
    when 11
      p "#{@name} ended up in space"
      revival
    end
  end

  def outcome
    @health       -= (rand(5)+1)
    @big_acorn     = 0
    @mood         -= (rand(3)+1)
    @irritability += (rand(3)+1)
    passage_of_time
  end

  def revival
    @big_acorn    = 0
    @life        -= 1
    @mood         = 9           
    @satiety      = 9          
    @thirst       = 9           
    @weariness    = 0           
    @irritability = 3           
    @health       = 9          
    passage_of_time
  end

  def passage_of_time # some time passes
    if @life < 1
      p "#{@name} has died :((("
      @fin = 'exit'
      exit  #  exit the game  
    end
  
    if @satiety > 0
      if Time.now() - @last_feed_time > 30
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
      if Time.now() - @last_drink_time > 15
         @thirst -= 1
      end
    else # Scrat is suffering from thirst
      p "#{@name} has lost 1 life due to thirst!"
      revival
    end

    if @weariness < 9
      if Time.now() - @last_rest_time > 60
         @weariness += 1
      end
    else # Scrat is exhausted
      p "#{@name} has lost 1 life due to exhaustion"
      revival   
    end
        
    if moody? 
      p "#{@name} has lost 1 life due to sorrow!"
      revival
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
      revival
    end
        
    if two_acorn?
      p "#{@name} tries to carry 2 acorns at the same time, loses both"
      @big_acorn     = 0
      @mood         -= 1
      @irritability += 1
    end
    htmlgen.generate 
    info
  end

end

class Htmlgen 
  
  attr_reader :life_em, :health_em, :mood_em, :satiety_em, :thirst_em, :weariness_em, :irritability_em, :big_acorn_em       

  # make emoji for html 

  def set_emojies
    @life_em         = life_emojies
    @health_em       = health_emojies
    @mood_em         = mood_emojies
    @satiety_em      = satiety_emojies
    @thirst_em       = thirst_emojies
    @weariness_em    = weariness_emojies
    @irritability_em = irritability_emojies
    @big_acorn_em    = big_acorn_emojies
  end

  def life_emojies
    combinated_emojies = "&#128512;" * @life + "&#128128;" * (9 - @life)
  end

  def health_emojies
    combinated_emojies = "&#128522;" * @health + "&#129397;" * (9 - @health)
    return combinated_emojies  if @health.between?(0, 9)
    emoji = @health.negative? ? "&#129397;" : "&#128522;"
    emoji  * 9
  end

  def mood_emojies  
    combinated_emojies = "&#128540;" * @mood + "&#129402;" * (9 - @mood)
    return combinated_emojies  if @mood.between?(0, 9)
    emoji = @mood.negative? ? "&#129402;" : "&#128540;"
    emoji  * 9
  end 

  def satiety_emojies
    combinated_emojies = "&#128523;" * @satiety + "&#129324;" * (9 - @satiety)
    return combinated_emojies  if @satiety.between?(0, 9)
    emoji = @satiety.negative? ? "&#129324;" : "&#128523;"
    emoji  * 9
  end

  def thirst_emojies
    combinated_emojies = "&#128167;" * @thirst + "&#128293;" * (9 - @thirst)
    return combinated_emojies  if @thirst.between?(0, 9)
    emoji = @satiety.negative? ? "&#128293;" : "&#128167;"
    emoji  * 9
  end

  def weariness_emojies
    combinated_emojies = "&#128553;" * @weariness + "&#128521;" * (9 - @weariness)
    return combinated_emojies  if @weariness.between?(0, 9)
    emoji = @weariness.negative? ? "&#128521;" : "&#128553;"
    emoji  * 9
  end

  def irritability_emojies
    combinated_emojies = "&#128127;" * @irritability + "&#129321;" * (9 - @irritability)
    return combinated_emojies  if @irritability.between?(0, 9)
    emoji = @irritability.negative? ? "&#129321;" : "&#128127;"
    emoji  * 9
  end
  
  def big_acorn_emojies
    emoji = @big_acorn.negative? ? "&#128683;" : "&#127792;"
  end


  def html
    # make html
    <<-HTML
      <div align="center"><img src="img/ice_age_t.png"></div>  
      <table align="center">
        <tr>
          <th rowspan="8"><h1>Hi, I'm Scrat!</h1></br>
            <img src="img/scrat.png">
          </th>
          <td><h2>Life</h2></td><td><h2> #{@life_em} </h2></td><td><button name="cure"><h3>Quit</h3></button></td>
        </tr>
        <tr>
          <td><h2>Health</h2></td><td><h2> #{@health_em} </h2></td><td><button name="cure"><h3>Give a Cure!</h3></button></td>
        </tr>
        <tr>
          <td><h2>Mood</h2></td><td><h2> #{@mood_em} </h2></td><td></td>
        </tr>
        <tr>
          <td><h2>Satiety</h2></td><td><h2> #{@satiety_em} </h2></td><td><button name="feed"><h3>Give a Food!</h3></button></td>
        </tr>
        <tr>
          <td><h2>Thirst</h2></td><td><h2> #{@thirst_em} </h2></td><td><button name="water"><h3>Give a Water!</h3></button></td>
        </tr>
        <tr>
          <td><h2>Weariness</h2></td><td><h2> #{@weariness_em} </h2></td><td><button name="bed"><h3>Put to Cave!</h3></button></td>
        </tr>
        <tr>
          <td><h2>Irritability</h2></td><td><h2> #{@irritability_em} </h2></td><td></td>
        </tr>
        <tr>
          <td><h2>Acorn</h2></td><td><h2> #{@big_acorn_em} </h2></td><td><button name="acorn"><h3>Give an Acorn!</h3></button></td>
        </tr>
      </table>
    HTML
  end

  def generate
    Haid.html_gen(html,  bypass_html: true) 
  end  
end


pet = Squirrel.new 'Scrat'
pet.game

