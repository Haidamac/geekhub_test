require 'haid'
require_relative 'iat'

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