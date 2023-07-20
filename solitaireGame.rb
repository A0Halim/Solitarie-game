require "./cardClass"

set title: "Solitre"
set viewport_width: 640*3, viewport_height: 480*3, background: "#4F4F4F"

def reset(cardAddressInf, flippedCardImg)
  Window.clear
  cardAddress = (0..cardAddressInf.length - 1).to_a.shuffle
  collectedCards = Array.new(4) {Array.new}
  mainCards = Array.new(7) {Array.new}
  remainCards = []

  cardPosition = Image.new(
    flippedCardImg,
    x: 100,
    y: 50,
    color: "black",
    opacity: 0.5
  )

  for i in (0..6)
  mainCards[i] << Kart.new(
    flippedCardImg,
    x: cardPosition.x + (i + 1) * 225,
    y: 50,
    z: -20,
    color: "black",
    position: [cardPosition.x + (i + 1) * 225, 0],
    opacity: 0.5,
    pile: i,
    value: 13,
    type: -1,
    special: true,
    canPlay: true
  )
  end

  for i in (0..3)
    collectedCards[i] << Kart.new(
    flippedCardImg,
    x: 100 + 225 * i,
    y: 1200,
    z: -20,
    canPlay: true,
    pile: 10 * (i + 1),
    color: "black",
    opacity: 0.5,
    value: -1,
    type: -1,
    special: true
  )
  end

  for i in (0..6) do
    for j in (0..i) do
      address = cardAddress.shift
      mainCards[i].unshift Kart.new(
      cardAddressInf[address],
      x: cardPosition.x + (i + 1)*225,
      y: 50 + j*50,
      z: -20,
      flipped: (unless j == i then true else false end),
      pile: i,
      address: address,
      position: [cardPosition.x + (i + 1) * 225, 50 + j * 50],
      canPlay:  (if j == i then true else false end),
      flippedCardImg: flippedCardImg
    )
    end
  end
  #Ortada olmayan cardsı kenara ekler
  cardAddress.each do |address|
    remainCards.unshift Kart.new(
      cardAddressInf[address],
      x: cardPosition.x,
      y: cardPosition.y,
      canPlay: true,
      flipped: true,
      address: address,
      flippedCardImg: flippedCardImg,
      position: [cardPosition.x, cardPosition.y]
    )
  end
  remainCards << nil
  [mainCards, remainCards, collectedCards, cardPosition]
end

cardTypes  = ["Hearts", "Spades", "Diamonds", "Clubs"]
cardValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
cardColors = ["blue", "green", "red"]

cardAddressInf = []
selectedStyle  = 1
selectedColor  = 0

cardTypes.each do |cardType|
  cardValues.each do |cardValue|
    cardAddressInf << "./Cards/card#{cardType}#{cardValue}.png"
  end
end

flippedCardImg = "./Cards/cardBack_#{cardColors[selectedColor]}#{selectedStyle}.png"
mainCards, remainCards, collectedCards, cardPosition = 0,0,0,0
gameWon = false
start = false
selectedCard = nil
deltaXY = []

startButton = Quad.new(
  x1: Window.viewport_width/2 - 250,
  y1: Window.viewport_height/2 - 200,
  x2: Window.viewport_width/2 + 250,
  y2: Window.viewport_height/2 - 200,
  x3: Window.viewport_width/2 + 250,
  y3: Window.viewport_height/2 - 100,
  x4: Window.viewport_width/2 - 250,
  y4: Window.viewport_height/2 - 100,
)
Text.new(
  "Start",
  x: startButton.x1 + 150,
  y: startButton.y1,
  size: 100,
  color: "black"
)
gorsel = Image.new(
  flippedCardImg,
  x: startButton.x4,
  y: startButton.y4 + 65
)
colorOptions = [
  [Square.new(
    x: startButton.x4 + 175,
    y: startButton.y4 + 50,
    size: 70, color: "black"
  ),Square.new(
    x: startButton.x4 + 185,
    y: startButton.y4 + 60,
    size: 50, color: "blue"), "blue"],
  [Square.new(
    x: startButton.x4 + 175,
    y: startButton.y4 + 125,
    size: 70, color: "white"
  ),Square.new(
    x: startButton.x4 + 185,
    y: startButton.y4 + 135,
    size: 50, color: "green"), "green"],
  [Square.new(
    x: startButton.x4 + 175,
    y: startButton.y4 + 200,
    size: 70, color: "white"
  ),Square.new(
    x: startButton.x4 + 185,
    y: startButton.y4 + 210,
    size: 50, color: "red"), "red"]]
styleOptions = [
  [Square.new(
    x: startButton.x4 + 275,
    y: startButton.y4 + 50,
    size: 70, color: "black"
  ),Text.new(
    "1",
    x: startButton.x4 + 295,
    y: startButton.y4 + 60,
    size: 50, color: cardColors[selectedColor])],
  [Square.new(
    x: startButton.x4 + 350,
    y: startButton.y4 + 50,
    size: 70, color: "white"
  ),Text.new(
    "2",
    x: startButton.x4 + 370,
    y: startButton.y4 + 60,
    size: 50, color: cardColors[selectedColor])],
  [Square.new(
    x: startButton.x4 + 275,
    y: startButton.y4 + 125,
    size: 70, color: "white"
  ),Text.new(
    "3",
    x: startButton.x4 + 295,
    y: startButton.y4 + 135,
    size: 50, color: cardColors[selectedColor])],
  [Square.new(
    x: startButton.x4 + 350,
    y: startButton.y4 + 125,
    size: 70, color: "white"
  ),Text.new(
    "4",
    x: startButton.x4 + 370,
    y: startButton.y4 + 135,
    size: 50, color: cardColors[selectedColor])],
  [Square.new(
    x: startButton.x4 + 275,
    y: startButton.y4 + 200,
    size: 70, color: "white"
  ),Text.new(
    "5",
    x: startButton.x4 + 295,
    y: startButton.y4 + 210,
    size: 50, color: cardColors[selectedColor]
  )]
]

on :mouse_down do |event|
  if start
    if cardPosition.contains?(event.x, event.y)
      if remainCards[0].nil?
        remainCards.each do |kart|
          next if kart.nil?
          kart.position = [cardPosition.x, cardPosition.y]
          kart.goPosition
          kart.flip
        end
      else
        deltaXY = [event.x - cardPosition.x, event.y - cardPosition.y]
        selectedCard = remainCards[0]
        selectedCard.position = [cardPosition.x, cardPosition.y + 300]
        selectedCard.flip
      end
      remainCards << remainCards.shift
    elsif cardPosition.contains?(event.x, event.y - 300)
      deltaXY = [event.x - cardPosition.x, event.y - cardPosition.y - 300]
      selectedCard = remainCards[-1]
    else
      mainCards.each do |cards|
        cards.each do |kart|
          if kart.canPlay && kart.image.contains?(event.x, event.y) && !kart.special
            deltaXY = [event.x - kart.x, event.y - kart.y]
            selectedCard = kart
            selectedCard.setLayer
            break
          end
        end
      end
    end
    collectedCards.each do |cards|
      if cards[0].image.contains?(event.x, event.y) && !cards[0].special
        deltaXY = [event.x - cards[0].x, event.y - cards[0].y]
        selectedCard = cards[0]
        break
      end
    end
  elsif startButton.contains?(event.x, event.y)
      mainCards, remainCards, collectedCards, cardPosition = reset(cardAddressInf, flippedCardImg)
      start = true
  else
    colorOptions.each_with_index do |x, i|
      if x[0].contains?(event.x, event.y) && x[2] != selectedColor
        colorOptions.map do |x| x[0].color = "white" end
        x[0].color = "black"
        selectedColor = i
        styleOptions.each do |x|
          x[1].color = cardColors[selectedColor]
        end
      end      
      x[0].color = "white" if selectedColor != i
    end
    styleOptions.each_with_index do |x, i|
      if x[0].contains?(event.x, event.y) && i + 1 != selectedStyle
        styleOptions.map do |x| x[0].color = "white" end
        x[0].color = "black"
        selectedStyle = i + 1
      end
    end
    flippedCardImg = "./Cards/cardBack_#{cardColors[selectedColor]}#{selectedStyle}.png"
    gorsel = Image.new(
      flippedCardImg,
      x: startButton.x4,
      y: startButton.y4 + 65
    )
  end
end

on :mouse do |event|
  if selectedCard
    selectedCard.x = (event.x.to_i/25)*25 - (deltaXY[0].to_i/25)*25
    selectedCard.y = (event.y.to_i/25)*25 - (deltaXY[1].to_i/25)*25
    unless selectedCard.connected.nil?
      selectedCard.followed
    end
  end
end

on :mouse_up do |event|
  if selectedCard
    mainCards.each_with_index do |cards, index|
      next if selectedCard.pile == index
      if cards[0].canPlay && cards[0].image.contains?(event.x, event.y) && cards[0].value == selectedCard.value + 1 && ((cards[0].type - selectedCard.type) % 2 == 1 || cards[0].type == -1) && cards[0].connected.nil?
        selectedCard.cutConnected
        selectedCard.position = [cards[0].x, if cards[0].special then cards[0].y else cards[0].y + 50 end]
        cards[0].connected = selectedCard
        selectedCard.cardUser = cards[0]

        if selectedCard.pile == -1
          cards.unshift remainCards.pop
          cards[0].pile = index
        elsif selectedCard.pile >= 10
          cards.unshift collectedCards[selectedCard.pile / 10 - 1].shift
          cards[0].pile = index
        else
          selectedCard.changePile(mainCards, index, selectedCard.pile)
        end

        break
      end
    end

    collectedCards.each do |cards|
      next if cards[0] == selectedCard
      if cards[0].image.contains?(event.x, event.y) && cards[0].value + 1 == selectedCard.value && ((cards[0].type == selectedCard.type) || cards[0].type == -1) && selectedCard.connected.nil?
        selectedCard.position = [cards[0].x, cards[0].y]
        selectedCard.z = selectedCard.value
        cards.unshift selectedCard
        selectedCard.cutConnected
        selectedCard.cardUser = nil

        if selectedCard.pile == -1
          remainCards.pop
        elsif selectedCard.pile >= 10
          collectedCards[selectedCard.pile / 10 - 1].shift
        else
          mainCards[selectedCard.pile].shift 
        end

        selectedCard.pile = cards[-1].pile

        if mainCards.all?{|cards| cards[0].type == -1}
          Text.new(
            "You Won",
            size: 100,
            x: Window.viewport_width/2 - 200,
            y: Window.viewport_height/2 - 100,
            color: "#AA0000"
          )
          Text.new(
            "Press R for play again",
            size: 35,
            x: Window.viewport_width/2 - 200,
            y: Window.viewport_height/2,
            color: "#F50000"
          )
        end
        break
      end
    end

    mainCards.each do |cards|
      next if cards[0].type == -1
      if cards[0].image.path == flippedCardImg
        cards[0].canPlay = true
        cards[0].flip
        break
      end
    end
    selectedCard.goPosition
  end
  selectedCard = nil
end

on :key_down do |event|
  if event.key == "r"
    mainCards, remainCards, collectedCards, cardPosition = reset(cardAddressInf, flippedCardImg)
  end
end

show
