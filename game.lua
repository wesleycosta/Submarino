-- Bibliotecas
require("desenhos");    
require("movimentos");
require("explosao");

PointColisao = {} -- quarda a posicao X e Y da explosao do submarino
PosicoesInimigos = {} -- lista para guardas as posicoes Y dos inimigos, evitando assim que com o sorteio nao caiam repeditamente na mesma posicao Y
Inimigos = {}  -- matriz que guarda dados dos inimigos, na posicao ** Inimigos[X][0] -> carrega img do inimigo ** Inimigos[x][1] -> resposavel por controlar o tempo de explosao do inimigo **
MissilSubmarino = {} -- vetor que guarda os misseis do submarino
MissilInimigos = {}  -- vetor que guarda os misseis dos inimigos
SomExplosao = {}     -- guardar o som de explosao, assim possibilitando que toquem simutaniamente
Beep = {}            -- guarda o som do "beep" no cronometro inicial
SomMissilInimigo = {} -- guarda o som do laser inimigo
PenteMissil = {}      -- guarda o desenho do missil, desenhado no  canto superior esquerdo
TempoCarregarMissil = -1 -- controla o tempo para recarregar o missil do submarino, onde ** -1 = tem tiro  
NumTiros, Contagem, Tempo, Pontos, ContInimigos = 0, 0, 0, 0, 0
GameOver, Comecou = false, false
MaxTiro = 6    VelMissil = 8    VelSubmarino = 6   VelInimigos = 9     VelMissilInimigo = 12    NumInimigos = 11

-- LOAD
function love.load()
  intro = love.audio.newSource("sound/intro.ogg", "static")
  intro:setLooping(true)

  SomMissil = {}
  QualTela = 2    MaxMenu = 2

  for i = 0, MaxTiro do 
    SomMissil[i] = love.audio.newSource("sound/laser.ogg", "static")
  end 
  for i = 0, NumInimigos + 1 do
    SomExplosao[i] = love.audio.newSource("sound/explosion.ogg", "static")
  end

  for i = 0, 3 do
    Beep[i] = love.audio.newSource("sound/beep.ogg", "static")
  end

  for i = 0, 5 do
    PenteMissil[i] = {img = drawable.newDrawable("img/missil_up.png", 50 + (i * 20), 20), config={}}
  end

  Submarino  = {img = drawable.newDrawable("img/sub.png", 20 , AreaY /2), config={}}
  Relogio  = {img = drawable.newDrawable("img/relogio.png", AreaX - 100 , 25), config={}}
  Score  = {img = drawable.newDrawable("img/pontos.png", AreaX - 280 , 25), config={}}
  Placa  = {img = drawable.newDrawable("img/placa.png",  25 , 20), config={}}
  

  MenuGameOver  = {img = drawable.newDrawable("img/menu/menugameover.png",  AreaX + 400 , AreaY / 2 - 175), config={}}
  MenuNovoJogo  = {img = AnimacaoIMG.NovaAnimacao("img/menu/jogar.png", AreaX + 544 , AreaY / 2 + 175, 140,  60, 142, 0), config={}}
  MenuSair      = {img = AnimacaoIMG.NovaAnimacao("img/menu/sair.png",  AreaX + 700 , AreaY / 2 + 175, 140,  60,   0, 0) , config={}}

  for i = 0, MaxTiro  do
    MissilSubmarino[i] =  {img = drawable.newDrawable("img/bomb.png",-20,-20),config = {}}
  end

  AtribuiPosicoes()
  
  for i = 0, NumInimigos do
    math.randomseed(os.clock())
    sorte = math.random(1, table.maxn(PosicoesInimigos))
    MissilInimigos[i] = {img = drawable.newDrawable("img/bomb2.png", AreaX + 400 , - 500 ),config = {}} 
    SomMissilInimigo[i] =  love.audio.newSource("sound/laser2.ogg", "static")
    Inimigos[i] = {} 
    Inimigos[i][0] = {}
    Inimigos[i][1] = {}
    if( i == 0) then
      Inimigos[i][0] =  {img = drawable.newDrawable("img/inimigo.png", AreaX + 400 , PosicoesInimigos[sorte] ),config = {}}
    else
      Inimigos[i][0] =  {img = drawable.newDrawable("img/inimigo.png", Inimigos[i - 1][0].img.x + 250, PosicoesInimigos[sorte] ),config = {}}
    end
    
    Inimigos[i][1] =  -1
    table.remove(PosicoesInimigos, sorte)
    table.sort(PosicoesInimigos)
  end

end

--DRAW
function love.draw()
  if(not GameOver) then
        if(not Comecou) then
            Cronometro()
        end  
        DesenhaMissilInimigos()
        DesenhaInimigos(true)
        MissilAcertouInimigo()
        DrawFundo(true)

        for i = 0, NumInimigos do
          if(Inimigos[i][1] >= 0) then
            Anime(i)
          end
        end

        if(NumTiros <= MaxTiro) then
            DesenhaMissilSubmarino() --Desenha os tiros da nave  

        end

        draw(Submarino.img)
  else
        DrawFundo(false)
        DesenhaInimigos(false)
        DesenhaExplosao(PointColisao['x'], PointColisao['y'])
  end
    draw(Relogio.img)   draw(Score.img)    draw(Placa.img)

    EscreveNaTela(string.format("%.4d", Tempo),  AreaX - 034, 40, 2)
    EscreveNaTela(string.format("%.5d", Pontos), AreaX - 222, 40, 2)

    if((NumTiros == MaxTiro or TempoCarregarMissil >= 0) and not GameOver)then
      EscreveNaTela("Carregando", 45, 40, 2)
      EscreveNaTela("Carregando: ".. string.format("%.1f",((TempoCarregarMissil - 2) * -1)), Submarino.img.x, Submarino.img.y + 105, 1)
    else
      for i = 0, ((NumTiros - MaxTiro + 1) * - 1) do
        draw(PenteMissil[i].img)
      end
    end
    draw(MenuGameOver.img)
    draw(MenuSair.img)
    draw(MenuNovoJogo.img)
end

--UPDATE
function love.update()
   if(Comecou and not GameOver) then
      Bateu()
      Tempo = Tempo + 0.03
      if(TempoCarregarMissil >= 0 and TempoCarregarMissil < 2) then
        TempoCarregarMissil = TempoCarregarMissil + 0.01
      end
      if(TempoCarregarMissil >= 2) then
        TempoCarregarMissil = -1
      end
      MoverSubmarino()
      MissilAcertouInimigo()
      MissilAcertouSubmarino()
      for i= 0, NumInimigos do
        if(Inimigos[i][1] >= 0) then
          Inimigos[i][1] = Inimigos[i][1] + 0.01
          if(Inimigos[i][1] > 0.35) then
            Inimigos[i][0].img.x, Inimigos[i][0].img.x = - 200, - 200 
            Inimigos[i][1] = -1
          end
        end        
      end
   else
      TempoAnimeExplosao()
      Contagem = Contagem + 1
      if(Contagem >= 100) then
          Contagem = 0
          Comecou = true
          love.audio.play(intro)
      end
  end
  if(GameOver) then
    AnimeMenu(MenuGameOver, AreaX/2 - 230)
    AnimeMenu(MenuNovoJogo, AreaX/2 - 96)
    AnimeMenu(MenuSair,     AreaX/2 + 60)
  end
end

-- funcao para zerar as variaveis e colocar os desenhos em posicoes para um novo jogo
function NovoJogo()
  love.audio.stop(intro)
	GameOver, Comecou = false, false
  ContInimigos, NumTiros, Contagem, Tempo, Pontos, TempoExplosao = 0, 0, 0, 0, 0, 0
  TempoCarregarMissil = -1  tempo = 1
  VelInimigos = 9  VelMissilInimigo = 12
  Submarino  = {img = drawable.newDrawable("img/sub.png", 20 , AreaY /2), config={}}
  MenuGameOver  = {img = drawable.newDrawable("img/menu/menugameover.png",  AreaX + 400 , AreaY / 2 - 175), config={}}
  
  for i = 0, MaxTiro  do
    MissilSubmarino[i] =  {img = drawable.newDrawable("img/bomb.png",-20,-20),config = {}}
  end

  AtribuiPosicoes()
  SorteiaPosicoes()
  MenuNovoJogo  = {img = AnimacaoIMG.NovaAnimacao("img/menu/jogar.png", AreaX + 544 , AreaY / 2 + 175, 140,  60, 142, 0), config={}}
  MenuSair      = {img = AnimacaoIMG.NovaAnimacao("img/menu/sair.png",  AreaX + 700 , AreaY / 2 + 175, 140,  60,   0, 0) , config={}}
end


function  MudaFocusGameOver()
  if(OpMenu == 1) then
    MenuNovoJogo = {img = AnimacaoIMG.NovaAnimacao("img/menu/jogar.png", AreaX/2 - 96 , AreaY / 2 + 175, 140,  60, 142, 0), config={}}
    MenuSair     = {img = AnimacaoIMG.NovaAnimacao("img/menu/sair.png",  AreaX/2 + 60,  AreaY / 2 + 175, 140,  60,   0, 0) , config={}}
  else
    MenuNovoJogo = {img = AnimacaoIMG.NovaAnimacao("img/menu/jogar.png", AreaX/2 - 96 , AreaY / 2 + 175, 140,  60,   0, 0),  config={}}
    MenuSair     = {img = AnimacaoIMG.NovaAnimacao("img/menu/sair.png",  AreaX/2 + 60 , AreaY / 2 + 175, 140,  60, 142, 0) , config={}}
  end
end