const animals = ["🐶", "🐱", "🐰", "🦊", "🐻", "🐼", "🦁", "🐸"];

const board = document.getElementById("gameBoard");
const movesEl = document.getElementById("moves");
const pairsEl = document.getElementById("pairs");
const messageEl = document.getElementById("message");
const restartBtn = document.getElementById("restartBtn");

let cards = [];
let firstCard = null;
let secondCard = null;
let lockBoard = false;
let moves = 0;
let foundPairs = 0;

function shuffle(array) {
  return [...array].sort(() => Math.random() - 0.5);
}

function createBoard() {
  board.innerHTML = "";
  messageEl.textContent = "";
  moves = 0;
  foundPairs = 0;
  firstCard = null;
  secondCard = null;
  lockBoard = false;

  movesEl.textContent = moves;
  pairsEl.textContent = foundPairs;

  const gameAnimals = shuffle([...animals, ...animals]);

  cards = gameAnimals.map((animal, index) => {
    const card = document.createElement("div");
    card.className = "card";
    card.dataset.animal = animal;
    card.dataset.index = index;

    card.innerHTML = `
      <div class="card-inner">
        <div class="card-front">?</div>
        <div class="card-back">${animal}</div>
      </div>
    `;

    card.addEventListener("click", flipCard);
    board.appendChild(card);
    return card;
  });
}

function flipCard() {
  if (lockBoard) return;
  if (this === firstCard) return;
  if (this.classList.contains("matched")) return;

  this.classList.add("flipped");

  if (!firstCard) {
    firstCard = this;
    return;
  }

  secondCard = this;
  moves++;
  movesEl.textContent = moves;
  checkMatch();
}

function checkMatch() {
  const isMatch = firstCard.dataset.animal === secondCard.dataset.animal;

  if (isMatch) {
    firstCard.classList.add("matched");
    secondCard.classList.add("matched");
    foundPairs++;
    pairsEl.textContent = foundPairs;
    resetTurn();

    if (foundPairs === animals.length) {
      messageEl.textContent = `Bravo ! Tu as gagné en ${moves} coups.`;
    }
  } else {
    lockBoard = true;
    setTimeout(() => {
      firstCard.classList.remove("flipped");
      secondCard.classList.remove("flipped");
      resetTurn();
    }, 900);
  }
}

function resetTurn() {
  [firstCard, secondCard] = [null, null];
  lockBoard = false;
}

restartBtn.addEventListener("click", createBoard);

createBoard();