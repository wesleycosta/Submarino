---------------------- ** Guarda todas as funcoes relacionadas com "movimentos" ** -----------------
---------------------------------------------------------------------------------------------------
-- animacao de transisao vetical do menu
function AnimeMenu(img1, x1)
  if(img1.img.x > x1) then
    img1.img.x = img1.img.x - 20 
  end
end

-- funcao resposavel por verificar se o submarino bateu nos inimigos
function Bateu()
   for j = 0, NumInimigos do
       if((Submarino.img.y >= Inimigos[j][0].img.y - 80 and Submarino.img.y <= Inimigos[j][0].img.y + 90) and (Submarino.img.x >= Inimigos[j][0].img.x - 80 and Submarino.img.x <= Inimigos[j][0].img.x + 100) and Inimigos[j][1] <= -1) then
          GameOver = true
          PointColisao['x'], PointColisao['y'] = ((Submarino.img.x + Inimigos[j][0].img.x)/2), Submarino.img.y -- atribui posicoes X e Y para mostar explosao no lugar que o submarino bateu
          Submarino.img.x, Submarino.img.y = -200, - 200 -- remove o submarino da tela
          Inimigos[j][0].img.y,  Inimigos[j][0].img.x = -200, - 200 -- remove o inimigo da tela
          love.audio.play(SomExplosao[0]) -- reproduz o som de explosao
        end
   end
end


-- Dispara tiros da nave
function DisparaTiro()
  if(NumTiros < MaxTiro and TempoCarregarMissil == -1) then -- se tiver tiro no pente e nao estiver carregando entao 
    love.audio.play(SomMissil[NumTiros]) -- reproduz som do missil
    MissilSubmarino[NumTiros].img.x = Submarino.img.x + 80 -- posiciona missil na posicao X
    MissilSubmarino[NumTiros].img.y = Submarino.img.y + 60 -- posiciona missil na posicao Y
    DesenhaMissilSubmarino() -- desenha missil
    NumTiros = NumTiros + 1  -- incrementa o numero de tiros disparados
    if(NumTiros == MaxTiro) then -- se foi o ultimo tiro, entao recarrega o pente
        TempoCarregarMissil = 0
    end
   end
end

-- Desenha missil do submarino
function DesenhaMissilSubmarino()
    -- laco para desenha cada bomba do submarino na tela
    for j = 0, NumTiros - 1 do 
        draw(MissilSubmarino[j].img) -- desenha bomba na tela
        MissilSubmarino[j].img.x =MissilSubmarino[j].img.x + VelMissil -- move 15px da bomba para frente
    end
      -- verifica se o ultimo missil ja saiu da tela
    if(MissilSubmarino[MaxTiro - 1].img.x > AreaX + 100) then
        for j = 0, MaxTiro -1 do
          MissilSubmarino[j].img.x = AreaX
        end
        NumTiros = 0
    end
end

-- Verifica se o tiro do submarino acertou os inimigos
function MissilAcertouInimigo()
    for z = 0, MaxTiro do -- laco que percorre todos os misseis do submarino
      for w = 0, NumInimigos do
         if((MissilSubmarino[z].img.y > Inimigos[w][0].img.y and MissilSubmarino[z].img.y < Inimigos[w][0].img.y + 105) and (MissilSubmarino[z].img.x + 30 >= Inimigos[w][0].img.x  and  MissilSubmarino[z].img.x < Inimigos[w][0].img.x + 120) and  Inimigos[w][1] <= -1 and MissilSubmarino[z].img.x < AreaX) then 
           love.audio.play(SomExplosao[w])
            Inimigos[w][1] = 0 -- atribui 0 no inimigo que é "eliminado"  
            MissilSubmarino[z].img.x, MissilSubmarino[z].img.y  =  AreaX + 600, - 1000 -- remove missil da tela
            --Eliminados = Eliminados + 1
            Pontos = Pontos + 10
        end
      end
    end
end

-- funcao para posicionar submarinos no eixo Y
function AtribuiPosicoes()
  PosicoesInimigos[0] = ""
  for i = 130, AreaY - 80, 155 do 
    table.insert(PosicoesInimigos, i)
    table.insert(PosicoesInimigos, i)
    table.insert(PosicoesInimigos, i)
  end
end

-- funcao resposavel por sortear novas posicoes do submarino, usando um lista que quadar as posicoes
function SorteiaPosicoes()
  AtribuiPosicoes()
  for i = 0, NumInimigos do
    sorte = math.random(1, table.maxn(PosicoesInimigos)) -- sorteia um posicao da lista PosicoesInimigos
    if( i == 0) then
      Inimigos[i][0] =  {img = drawable.newDrawable("img/inimigo.png", AreaX + 300 , PosicoesInimigos[sorte] ),config = {}}
    else
      Inimigos[i][0] =  {img = drawable.newDrawable("img/inimigo.png", Inimigos[i - 1][0].img.x + 250, PosicoesInimigos[sorte] ),config = {}}
    end
    MissilInimigos[i].img.x, MissilInimigos[i].img.y =   AreaX + 400 , - 500  
    Inimigos[i][1] = -1 -- zera o tempo de explosao
    table.remove(PosicoesInimigos, sorte) -- remove a posicao da lista 
   -- table.sort(PosicoesInimigos) -- ordena a lista
  end
end

-- Funcao para verificar se o missil do inmigo acertou o submarino
function MissilAcertouSubmarino()
   for i = 0, NumInimigos do
  -- Verifica se o missil do inmigo acertou o submarino
     if ((MissilInimigos[i].img.y >= Submarino.img.y and MissilInimigos[i].img.y <= Submarino.img.y + 100) and 
        (MissilInimigos[i].img.x >= Submarino.img.x and MissilInimigos[i].img.x <= Submarino.img.x + 100)) then

        GameOver = true
        PointColisao['x'], PointColisao['y'] = Submarino.img.x, Submarino.img.y -- desenha explosao no lugar na posicao do submarino
        love.audio.play(SomExplosao[0]) -- reproduz o som de explosao

      end
    end
end


-- Desenha os Inimigos na tela
function DesenhaInimigos(mover)
    if(Comecou) then
       for z = 0, NumInimigos do
            draw(Inimigos[z][0].img) -- Desenha os invarores na tela
            if (Inimigos[z][1] <= -1 and mover) then -- verifica se o inimigo esta na tela ou ja foi eliminido
            
                Inimigos[z][0].img.x = Inimigos[z][0].img.x - VelInimigos -- move os inimigos
                
               ------------------------------------ MOVIMENTOS DOS INIMIGOS --------------------------------------------------
               -- Todos os inimigos que nao sao divisiveis por 2 e ira descer quando estiverem na posicao (AreaX - 100)
                if(z  % 2 ~= 0 and Inimigos[z][0].img.x < AreaX - 100 and Inimigos[z][0].img.y > 130) then
                  Inimigos[z][0].img.y = Inimigos[z][0].img.y - 3
                end
 
                -- Todos os inimigos que sao divisiveis por 2 ira subir quando estiverem na posicao (AreaX - 100)
                if(z % 2 == 0 and Inimigos[z][0].img.x < AreaX - 150 and Inimigos[z][0].img.y < AreaY - 110) then
                  Inimigos[z][0].img.y = Inimigos[z][0].img.y + 3
                end
 
                -- todos que forem divisiveis por 4 iram desvir do missil do submarino
                if(z % 4 == 0 and NumTiros > 0) then
                  for w = 0, MaxTiro do
                    if(w ~= 0 and (MissilSubmarino[w].img.y > Inimigos[z][0].img.y and MissilSubmarino[w].img.y < Inimigos[z][0].img.y + 120 and Inimigos[z][0].img.x < AreaX - 100)) then
                      if(Inimigos[z][0].img.y < AreaY - 120  and Inimigos[z][0].img.x < Submarino.img.x + 200) then
                        Inimigos[z][0].img.y = Inimigos[z][0].img.y + 4
                      elseif(Inimigos[z][0].img.y  > 100 and Inimigos[z][0].img.x < Submarino.img.x + 200) then
                             Inimigos[z][0].img.y = Inimigos[z][0].img.y - 4
                      end
                    end
                  end
               end

               -- todos inimigos que sao divisiveis por 2 e != de 0, irao seguir a posicao Y do submarino
               if(z % 2 == 0 and z ~= 0) then
                  if(Inimigos[z][0].img.y < Submarino.img.y + 50 and Inimigos[z][0].img.y < AreaY - 120) then -- se o inimigo estiver acima do submarino entao
                      Inimigos[z][0].img.y = Inimigos[z][0].img.y + 3 -- move 3px para cima
                  elseif(Inimigos[z][0].img.y > Submarino.img.y - 60) then -- se o inimigo estiver debaixo do submarino entao
                      Inimigos[z][0].img.y = Inimigos[z][0].img.y - 3 -- move 3px para baixo
                  end
              end
              ------------------------------------------------------------------------------------------------------------------
          end
            
            -- verifica se o inimigo ja esta aparecendo na tela, na posicao AreaX - 100, caso esteje dispara o tiro
            if(Inimigos[z][0].img.x < AreaX - 100 and z >= ContInimigos) then -- Dispara os tiros dos Aliens
                 love.audio.play(SomMissilInimigo[z]) -- reproduz o som de tiro dos inimigos
                 MissilInimigos[z].img.y = Inimigos[z][0].img.y + 60 -- Posiciona tiro aliens no eixo Y
                 MissilInimigos[z].img.x = Inimigos[z][0].img.x - 20 -- Posiciona tiro aliens no eixo X
                 draw(MissilInimigos[z].img) -- Desenha o tiro dos aliens
                 ContInimigos = ContInimigos + 1  -- var pra controlar qual alien vai atirar
             end
        end

        local TempContadorInimigos = 0
        for j = 0, NumInimigos do -- conta quantos inimigos foram eliminados ou ja passaram a tela
          if(Inimigos[j][0].img.x > -100) then 
            TempContadorInimigos = TempContadorInimigos + 1
          end
        end

    -- se todos o inimigos foram eliminados ou ja passaram a tela, manda outra tropa!
        if(TempContadorInimigos == 0) then 
        VelInimigos = VelInimigos + 1 -- aumenta a velocidade dos inimigos
        VelMissilInimigo = VelMissilInimigo + 1 -- aumenta a velocidade do missil inimigo
        SorteiaPosicoes() -- sorteia novas posicoes para os inimigos
        ContInimigos = 0
        end
    end
end


--Tratamento de movimento da Submarino
function MoverSubmarino()
  if(not GameOver and QualTela == 2) then
      --Mover Horizontalmente
      if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
          Submarino.img.x = Submarino.img.x - VelSubmarino
      end
      if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
          Submarino.img.x = Submarino.img.x + VelSubmarino
      end

      -- Mover Verticalmente
      if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
          Submarino.img.y = Submarino.img.y - VelSubmarino 
      end
      if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
          Submarino.img.y = Submarino.img.y + VelSubmarino 
      end

      --------------- Verificacao de limites do submarino -------------
      -- eixo X 
      if (Submarino.img.x  > AreaX - 55) then
          Submarino.img.x = AreaX - 55
      end
      if (Submarino.img.x < 5) then  
   
        Submarino.img.x = 5
      end

      -- eixo Y 
      if (Submarino.img.y > AreaY - 80) then
        Submarino.img.y = AreaY - 80
      end
      if (Submarino.img.y < 100) then
        Submarino.img.y = 100
      end
  end
end

---------------------------------- EVENTOS --------------------------------------
-- Evento keypress
function love.keypressed(key)

  if (key == "escape" and Comecou and QualTela == 2) then
    love.audio.stop(intro)
    love.filesystem.load('main.lua')()
    love.load()
  elseif (key == "escape" and main) then
     love.audio.stop()
     love.event.quit()
  elseif ((key == "space" or key == "x") and Comecou and not GameOver) then
    DisparaTiro()
  elseif (love.keyboard.isDown("n") and not main) then
    NovoJogo()
  end

  if(QualTela == 1) then -- se etiver na tela pricipal (inicio, menu)
    if (key == "down") then
      love.audio.play(SomBotao)
      OpMenu = OpMenu + 1
      if(OpMenu > MaxMenu) then
        OpMenu = 1
      end
    elseif (key == "up") then
      love.audio.play(SomBotao)
       OpMenu = OpMenu - 1
      if(OpMenu < 1 ) then
         OpMenu = MaxMenu
      end
    elseif (key == "space" or key == "return") then
      love.audio.play(ConfirmaOP)
      if(OpMenu == 1) then
        love.audio.stop(intro)
        QualTela = 2
        love.filesystem.load('game.lua')()
        love.load()
        NovoJogo()
      end
      if(OpMenu == 4) then
        love.audio.stop()
        love.event.quit()
      end
    end
    MudaFocusMenu()
  elseif(QualTela == 2 and GameOver and MenuGameOver.img.x <= AreaX/2 - 230) then
    if (key == "right") then
      love.audio.play(SomBotao)
      OpMenu = OpMenu + 1
      if(OpMenu > MaxMenu) then
        OpMenu = 1
      end
      MudaFocusGameOver()
    elseif (key == "left") then
       love.audio.play(SomBotao)
       OpMenu = OpMenu - 1
      if(OpMenu < 1 ) then
         OpMenu = MaxMenu
      end
      MudaFocusGameOver()
    elseif (key == "space" or key == "return" or key == "k") then
      if(OpMenu == 1) then
        NovoJogo()
      else
        love.audio.stop(intro)
        love.filesystem.load('main.lua')()
        love.load()
      end
    end
    
  end   
end