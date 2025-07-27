PFont font;
Card hoveredCard = null;

void drawPlayerCards(ArrayList<Card> hand, int y, boolean isActivePlayer) {
  int cardWidth = 70;
  int cardHeight = 100;
  int spacing = 40;
  int x = 50;
  
  textFont(font, 14);
  textSize(27);
  
  for (Card c : hand) {
    int offsetY = (c == hoveredCard) ? -20 : 0;
    
    if (isActivePlayer) {
      fill(255);
    } else {
      fill(200);
    }
    stroke(0);
    rect(x, y + offsetY, cardWidth, cardHeight, 10);
    
    if (c.suit == "♦" || c.suit == "♥") fill(255, 0, 0);
    else fill(0);
    text(c.suit, x + cardWidth / 2 - 20, y + 40 + offsetY);
    text(c.rank, x + cardWidth / 2 - 20, y + 18 + offsetY);
    
    x += spacing;
  }
}

void drawTableCard(int cx) {
  int cy = height / 2 - 80;
  int cardWidth = 70;
  int cardHeight = 100;
  int spacing = 20;
  
  for (int i = 0; i < tableCards.size(); i++) {
    Card c = tableCards.get(i);
    
    // Атакующая и отбивная пара карт рисуются с небольшим сдвигом по X
    int offsetX = (i / 2) * (cardWidth + spacing);
    int offsetY = (i % 2 == 0) ? 0 : 40; // Чуть ниже отбивная карта, чтобы визуально было понятно
    
    fill(255, 255, 256);
    stroke(0);
    rect(cx + offsetX + (i % 2) * 10, cy + offsetY, cardWidth, cardHeight, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    if (c.suit == "♦" || c.suit == "♥") fill(255, 0, 0);
    else fill(0);
    text(c.suit, cx + offsetX + (i % 2) * 10 + 30 / 2, cy + offsetY + 45);
    text(c.rank, cx + offsetX + (i % 2) * 10 + 30 / 2, cy + offsetY + 20);
  }
  
  // Козырная карта
  fill(255);
  rect(width - 120, height / 2 - 50, 70, 100, 5);
  fill(255);
  if (trump.suit == "♦" || trump.suit == "♥") fill(255, 0, 0);
  else fill(0);
  text(trump.suit, width - 100, height / 2);
  text(trump.rank, width - 100, 270);
}

Card getCardAtMouse(ArrayList<Card> hand, int y) {
  int cardWidth = 70;
  int cardHeight = 100;
  int spacing = 40;
  int xStart = 50;
  
  for (int i = hand.size() - 1; i >= 0; i--) { // идём с конца в начало
    int x = xStart + i * spacing;
    if (mouseX >= x && mouseX <= x + cardWidth && mouseY >= y && mouseY <= y + cardHeight) {
      return hand.get(i);
    }
  }
  return null;
}

void drawButtons() {
  textAlign(CENTER, CENTER);
  
  // Кнопка БИТО
  boolean canBeatOff = tableCards.size() > 0 && tableCards.size() % 2 == 0;
  fill(canBeatOff ? 255 : 100);
  rect(width / 2 - 200, height / 2 + 100, 100, 40, 10);
  fill(canBeatOff ? 0 : 255);
  text("БИТО", width / 2 - 150, height / 2 + 120);
  
  // Кнопка ЗАБРАТЬ
  boolean canTakeCards = tableCards.size() > 0 && tableCards.size() % 2 == 1;
  fill(canTakeCards ? 255 : 100);
  rect(width / 2 - 50, height / 2 + 100, 100, 40, 10);
  fill(canTakeCards ? 0 : 255);
  textSize(20);
  text("ЗАБРАТЬ", width / 2, height / 2 + 120);
}

void takeCards() {
  for (Card c : tableCards) {
    if (currentPlayer == 2) {
      player2.add(c);
    } else {
      player1.add(c);
    }
  }
  tableCards.clear();
  currentPlayer = currentAttacker; // Ход сохраняется у того, кто атаковал
  drawCardsTo6();
}

void beatCards() {
  for (Card c : tableCards) {
    beatedCards.add(c);
  }
  tableCards.clear();
  // Смена атакующего
  currentAttacker = (currentAttacker == 1) ? 2 : 1;
  currentPlayer = currentAttacker;
  drawCardsTo6();
}

void drawCardBack(float x, float y) {
  int w = 70;
  int h = 100;
  fill(180, 50, 50);
  stroke(0);
  rect(x, y, w, h, 10);
  
  stroke(255);
  for (int i = 10; i < w; i += 10) {
    line(x + i, y, x, y + i);
    line(x + w, y + i, x + i, y + h);
  }
}

void mainMenu() {
  textSize(72);
  fill(255);
  text("Дурак", width / 2, 50);
  
  rectMode(CENTER);
  if (mouseX >= 330 && mouseX <= 470 && mouseY >= 230 && mouseY <= 370) fill(200); else fill(255);
  rect(width / 2 - 100, height / 2, 140, 140, 10);
  
  if (mouseX >= 530 && mouseX <= 670 && mouseY >= 230 && mouseY <= 370) fill(200); else fill(255);
  rect(width / 2 + 100, height / 2, 140, 140, 10);
  
  fill(0);
  textSize(24);
  text("Создать\nигру", width / 2 - 100, height / 2);
  textSize(20);
  text("Подключиться", width / 2 + 100, height / 2);
  
  if (role.equals("")) {
    if (mousePressed && mouseX >= 330 && mouseX <= 470 && mouseY >= 230 && mouseY <= 370) { // СЕРВЕР
      role = "server";
      server = new Server(this, port);
      println("Сервер запущен на порту " + port);
    }
    
    if (mousePressed && mouseX >= 530 && mouseX <= 670 && mouseY >= 230 && mouseY <= 370) { // КЛИЕНТ
      role = "client";
      client = new Client(this, serverIP, port);
      connected = true;
      println("Подключение к серверу " + serverIP);
    }
  }
}
