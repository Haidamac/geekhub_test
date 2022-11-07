require_relative 'squirrel'
require 'haid'
require 'os'

class IceAge
  
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
        @squirrel.give_food
      when 'water'  
        @squirrel.give_water
      when 'bed'  
        @squirrel.put_to_cave
      when 'cure'
        @squirrel.give_cure
      when 'acorn'
        @squirrel.give_acorn
      when 'html'
        Haid.html_gen(html,  bypass_html: true) 
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

  # statistics in browser
  def html
    # make emoji for html 
    @life_em         = "&#128512;" * @life + "&#128128;" * (9 - @life)
    if @health <= 10 && @health >= 0
      @health_em     = "&#128522;" * @health + "&#129397;" * (10 - @health)
    elsif @health < 0
      @health_em     = "&#129397;" * 10 
    else
      @health_em     = "&#128522;" * 10
    end
    if @mood <= 5 && @mood >= 0
      @mood_em       = "&#128540;" * @mood + "&#129402;" * (5 - @mood)
    elsif @mood < 0
      @mood_em       = "&#129402;" * 5
    else
      @mood_em       = "&#128540;" * 5
    end
    if @satiety <=10 && @satiety >= 0
      @satiety_em    = "&#128523;" * @satiety + "&#129324;" * (10 - @satiety)
    elsif @satiety < 0
      @satiety_em    = "&#129324;" * 10
    else
      @satiety_em    = "&#128523;" * 10
    end
    if @thirst <= 7 && @thirst >= 0
      @thirst_em     = "&#128167;" * @thirst + "&#128293;" * (7 - @thirst)
    elsif @thirst < 0
      @thirst_em     = "&#128293;" * 7  
    else
      @thirst_em     = "&#128167;" * 7
    end
    if @weariness <= 10 && @weariness >= 0
      @weariness_em  = "&#128553;" * @weariness + "&#128521;" * (10 - @weariness)
    elsif @weariness < 0
      @weariness_em  = "&#128521;" * 10
    else
      @weariness_em  = "&#128553;" * 10
    end
    if @irritability <=10 && @irritability >= 0
      @irritability_em = "&#128127;" * @irritability + "&#129321;" * (10 - @irritability)
    elsif @irritability < 0
      @irritability_em = "&#129321;" * 10
    else
      @irritability_em = "&#128127;" * 10
    end
    if @big_acorn > 0
      @big_acorn_em  = "&#127792;" * @big_acorn
    else
      @big_acorn_em  = "&#128683;"
    end

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
end     

IceAge.game

