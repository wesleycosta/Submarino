drawable={
    newDrawable = 
    function (caminho, x, y)
        local Fig = {}
        img = love.graphics.newImage(caminho) -- caminho da imagem
        quad= love.graphics.newQuad(0, 0, img:getWidth(), img:getHeight(),img:getWidth(), img:getHeight())
        Fig["img"]=img
        Fig["quad"]=quad
        Fig["x"]=x
        Fig["y"]=y
        Fig["width"] = img:getWidth()
        Fig["height"] = img:getHeight()
        return Fig
    end
}

AnimacaoIMG={
    NovaAnimacao = function (caminho, x, y, TamanhoX, TamanhoY, PosicaoX, PosicaoY)
        local Fig = {}
        img = love.graphics.newImage(caminho) -- caminho da imagem
        quad= love.graphics.newQuad(PosicaoX, PosicaoY, TamanhoX, TamanhoY,img:getWidth(), img:getHeight())
        Fig["img"]=img
        Fig["quad"]= quad
        Fig["x"]=x
        Fig["y"]=y
        Fig["width"] = img:getWidth()
        Fig["height"] = img:getHeight()
        return Fig
    end
}


Fonts = {
    Grande =  love.graphics.newFont("fonts/Cartwheel.otf", 130),
    Pequeno =  love.graphics.newFont("fonts/Cartwheel.otf", 20),
    Medio =  love.graphics.newFont("fonts/Cartwheel.otf", 25) 
}

------------------- Ajusta tela --------------------
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(46,92,126)
    love.window.setFullscreen(true, "desktop")
    AreaX = love.graphics.getWidth( ) - 80
    AreaY = love.graphics.getHeight() - 70  
----------------------------------------------------

Rodape = {}         Topo = {}
MaxFundo = 3        VelFundo = 3

for i = 0, MaxFundo do
      if(i == 0) then
        Rodape[i] = {img = drawable.newDrawable("img/rodape.png", 0, AreaY), config = {}}
      else
        Rodape[i] = {img = drawable.newDrawable("img/rodape.png", Rodape[i-1].img.x + 500, AreaY), config = {}}
      end
  end
  for i = 0, MaxFundo do
      if(i == 0) then
        Topo[i] = {img = drawable.newDrawable("img/topo.png", 0, 0), config = {}}
      else
        Topo[i] = {img = drawable.newDrawable("img/topo.png", Topo[i-1].img.x + 489, 0), config = {}}
      end
end


----------------------------------------- Funcoes ----------------------------------------------------

--Desenha um objeto drawable na tela
function draw(Fig)
     love.graphics.draw(Fig.img, Fig.quad, Fig.x, Fig.y) --draw desenha um objeto do tipo quad
end

-- cronometro -> 3, 2, 1 , GO
function Cronometro()
    if(Contagem >= 0 and Contagem <= 25) then
        love.audio.play(Beep[0])
        EscreveNaTela("3",  AreaX/2 + 6,  AreaY/2 - 60, 3)
    elseif(Contagem > 25 and Contagem <= 50) then
        love.audio.play(Beep[1])
        EscreveNaTela("2",  AreaX/2 + 6,  AreaY/2 - 60, 3)
    elseif(Contagem > 50 and Contagem <= 75) then
        love.audio.play(Beep[2])
        EscreveNaTela("1",  AreaX/2 + 6, AreaY/2 - 60, 3)
    elseif(Contagem > 75 and Contagem <= 100) then
        love.audio.play(Beep[3])
        EscreveNaTela("GO", AreaX/2 - 26, AreaY/2 - 60, 3)
    end
end

-- Funcao para escrever um texto na tela, onde recebe por paremetro o texto, posicao x e y e o tamanho da fonte
function EscreveNaTela(texto, x, y, tamanho)
  love.graphics.setColor(255,255,255)
  if(tamanho == 1) then  -- tamanho -> 3 = Grande, 2 = Medio, 1 = Pequeno
     love.graphics.setFont(Fonts.Pequeno)
  elseif(tamanho == 2) then
      love.graphics.setFont(Fonts.Medio)
  elseif(tamanho == 3) then
    love.graphics.setFont(Fonts.Grande)
  end
  love.graphics.print(texto, x, y)
end

-- Desenha o fundo da tela
function DrawFundo(mover)
    for i = 0, MaxFundo do -- animacao no fundo se movendo 
      if(mover) then
        Rodape[i].img.x = Rodape[i].img.x - VelFundo 
        Topo[i].img.x = Topo[i].img.x - VelFundo
        
        if(Rodape[i].img.x  < -500) then -- verifica se o rodape ja saiu da tela, caso sim posiciona ele na fila
            if(i  == 0) then
                Rodape[0].img.x = Rodape[MaxFundo].img.x + 500
            else
                Rodape[i].img.x = Rodape[i - 1].img.x + 500
            end
        end
        if(Topo[i].img.x  <= -484) then -- verifica se o rodape ja saiu da tela, caso sim posiciona ele na fila
            if(i  == 0) then
                Topo[0].img.x = Topo[MaxFundo].img.x + 485
            else
                Topo[i].img.x = Topo[i - 1].img.x + 485
            end
        end
      end
      draw(Rodape[i].img)
      draw(Topo[i].img)
    end
end


-- funcao resposavel pela animacao de explosao dos inimigos
function Anime(pos) 
  draw(Inimigos[pos][0].img)
  local  _Xinimigo, _Yinimigo = Inimigos[pos][0].img.x, Inimigos[pos][0].img.y

  if(Inimigos[pos][1] < 0.05) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,  0,0),config = {}}
  elseif(Inimigos[pos][1] < 0.10) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,120,0),config = {}}
  elseif(Inimigos[pos][1] < 0.15) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,240,0),config = {}}
  elseif(Inimigos[pos][1] < 0.20) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,360,0),config = {}}
  elseif(Inimigos[pos][1] < 0.25) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,480,0),config = {}}
  elseif(Inimigos[pos][1] < 0.30) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,600,0),config = {}}
  elseif(Inimigos[pos][1] < 0.35) then
    Inimigos[pos][0] = {img = AnimacaoIMG.NovaAnimacao("img/explosao.png", _Xinimigo, _Yinimigo, 120,120,720,0),config = {}}
  end
end

-- funcao resposavel por desenhar os misseis inimigos
function DesenhaMissilInimigos()
     for j = 0, ContInimigos - 1 do -- laco para percorer ate o ultimo inimigo que disparou o missil
        MissilInimigos[j].img.x = MissilInimigos[j].img.x - VelMissilInimigo  -- move o missil dos inimigos
        draw(MissilInimigos[j].img) -- Desenha os misseis dos inmigos
     end
end