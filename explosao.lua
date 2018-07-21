TempoExplosao = 0
tempo = 1
Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", - 200, - 200, 120,120,0,0),config = {}}

function DesenhaExplosao(x, y)
	if(GameOver) then
	   tempo = 0
	   if(TempoExplosao < 0.05) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,0,0),config = {}}         
	   elseif(TempoExplosao < 0.10) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,120,0),config = {}}
	   elseif(TempoExplosao < 0.15) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,240,0),config = {}}
	   elseif(TempoExplosao < 0.20) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,360,0),config = {}}
	   elseif(TempoExplosao < 0.25) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,480,0),config = {}}
	   elseif(TempoExplosao < 0.30) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,600,0),config = {}}
	   elseif(TempoExplosao < 0.35) then
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", x, y, 120,120,720,0),config = {}}
	    else
	      Explosao = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", -300, -300, 120,120,720,0),config = {}}
	   end
	   draw(Explosao.img)
	end
end

function TempoAnimeExplosao()
	if(tempo <= 0.35) then
	  TempoExplosao = TempoExplosao  + 0.01
	end
end