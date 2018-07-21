require("desenhos");    
require("movimentos");

QualTela = 1   -- variavel para guardar qual tela esta sendo 'executada' sendo ---> 1 = main, 2 = game
OpMenu = 1     -- variavel para guardar qual opcao esta com focus 
MaxMenu = 4    -- numeto maximo de opcoes
local Menu = {} -- vetor que guarda o menu principal
local CaminhoOpcoes = {"img/menu/jogar.png", "img/menu/recordes.png", "img/menu/creditos.png", "img/menu/sair.png"}

-- LOAD
function love.load()
    --intro = love.audio.newSource("sound/intro.ogg", "stream")
    SomBotao = love.audio.newSource("sound/button.ogg", "stream")
    ConfirmaOP = love.audio.newSource("sound/confirma.ogg", "stream")
    intro = love.audio.newSource("sound/intro.ogg", "stream")
    intro:setLooping(true)
    love.audio.play(intro)

    QualTela = 1
    MenuRecordes = {img = drawable.newDrawable("img/menu/mainrecordes.png", AreaX + 400, AreaY / 2 - 160), config = {}}
    Menu[0] = {img = drawable.newDrawable("img/menu/menu.png", AreaX / 2 - 140, AreaY / 2 - 180), config = {}}
    MudaFocusMenu()
end

--DRAW
function love.draw()
    DrawFundo(false)
    draw(MenuRecordes.img)
    for i = 0, 4 do 
       draw(Menu[i].img)
    end
end

--UPDATE
function love.update()
    MudaFocusMenu()
end

-- funcao para mudar a cor do botao selecionado
function  MudaFocusMenu()
    for i = 1, 4 do
        if(i == 1) then 
            if(OpMenu == 1) then
                Menu[1] = {img = AnimacaoIMG.NovaAnimacao(CaminhoOpcoes[1], AreaX / 2 - 30, AreaY / 2 - 70, 140, 60, 142, 0), config = {}}
            else
                Menu[1] = {img = AnimacaoIMG.NovaAnimacao(CaminhoOpcoes[1], AreaX / 2 - 30, AreaY / 2 - 70, 140, 60,   0, 0), config = {}}
            end
        else
            if(i ~= OpMenu) then -- se for diferento do botao com focus, entao desenha botao amarelo
                 Menu[i] = {img = AnimacaoIMG.NovaAnimacao(CaminhoOpcoes[i], AreaX / 2 - 30, Menu[i -1].img.y + 60, 140, 60,   0, 0), config = {}}
            else -- senao desenha botao laranja
                 Menu[i] = {img = AnimacaoIMG.NovaAnimacao(CaminhoOpcoes[i], AreaX / 2 - 30, Menu[i -1].img.y + 60, 140, 60, 142, 0), config = {}}
            end 
        end
    end
end