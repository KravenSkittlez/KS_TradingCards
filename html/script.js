// ===== State =====
let currentCollection = [];
let currentPage = 0;
let filteredCards = [];
const CARDS_PER_PAGE = 18; // 9 per page side × 2 sides

// ===== Rendering =====
function renderCollection(filterBy = "", sortBy = "name") {
  // Use parameters if provided, otherwise get from UI elements
  const rarityFilter = filterBy || (document.getElementById("filter") ? document.getElementById("filter").value : "");
  const sortValue = sortBy || (document.getElementById("sort") ? document.getElementById("sort").value : "name");

  filteredCards = currentCollection;

  if (rarityFilter && rarityFilter !== "") {
    filteredCards = filteredCards.filter(c => c.rarity === rarityFilter);
  }

  if (sortValue === "name") {
    filteredCards.sort((a, b) => a.name.localeCompare(b.name));
  } else if (sortValue === "rarity") {
    filteredCards.sort((a, b) => a.rarity.localeCompare(b.rarity));
  } else if (sortValue === "amount") {
    filteredCards.sort((a, b) => (b.amount || 0) - (a.amount || 0));
  }

  currentPage = 0; // Reset to first page when filtering/sorting
  renderCurrentPage();
}

function renderCurrentPage() {
  const startIndex = currentPage * CARDS_PER_PAGE;
  const endIndex = startIndex + CARDS_PER_PAGE;
  const pageCards = filteredCards.slice(startIndex, endIndex);

  // Clear both pages
  const leftPageDiv = document.getElementById("leftPageCards");
  const rightPageDiv = document.getElementById("rightPageCards");
  if (!leftPageDiv || !rightPageDiv) return;
  leftPageDiv.innerHTML = "";
  rightPageDiv.innerHTML = "";

  // Fill left page (first 9)
  for (let i = 0; i < 9 && i < pageCards.length; i++) {
    const card = pageCards[i];
    const div = createCardElement(card);
    leftPageDiv.appendChild(div);
  }

  // Fill right page (next 9)
  for (let i = 9; i < 18 && i < pageCards.length; i++) {
    const card = pageCards[i];
    const div = createCardElement(card);
    rightPageDiv.appendChild(div);
  }

  updatePageNavigation();  // also rebuilds tabs
}

function createCardElement(card) {
  const div = document.createElement("div");
  div.className = `card rarity-${(card.rarity || "").toLowerCase()}`;
  div.innerHTML = `
    <img src="images/${card.image}" class="card-img" onerror="console.log('Failed to load collection image: images/${card.image}')">
  `;
  return div;
}

function getTotalPages() {
  return Math.max(1, Math.ceil(filteredCards.length / CARDS_PER_PAGE));
}

function updatePageNavigation() {
  const totalPages = getTotalPages();
  // pageInfo was removed from the DOM, so we do not touch it anymore.
  renderPageTabs(totalPages);
}

function renderPageTabs(totalPages) {
  const tabsRoot = document.getElementById("pageTabs");
  if (!tabsRoot) return;

  tabsRoot.innerHTML = "";
  for (let i = 0; i < totalPages; i++) {
    const tab = document.createElement("div");
    tab.className = "page-tab";
    tab.setAttribute("role", "button");
    tab.setAttribute("aria-label", `Go to page ${i + 1}`);
    tab.dataset.index = i.toString();
    tab.textContent = `${i + 1}`;
    if (i === currentPage) tab.classList.add("active");

    tab.addEventListener("click", () => {
      currentPage = i;
      renderCurrentPage();
    });

    tabsRoot.appendChild(tab);
  }
}

// ===== Message handler from client (NUI) =====
window.addEventListener("message", function (event) {
  const data = event.data;
  if (!data || !data.action) return;

  if (data.action === "showPackResult") {
    const packDiv = document.getElementById("pack-result");
    const cardsDiv = document.getElementById("cards");
    const title = document.querySelector("#pack-result h1");
    if (!packDiv || !cardsDiv || !title) return;

    title.textContent = `Pack Opened!`;
    cardsDiv.innerHTML = "";

    (data.cards || []).forEach(card => {
      const div = document.createElement("div");
      div.className = "card";
      div.innerHTML = `
        <img src="images/${card.image}" class="card-img" onerror="console.log('Failed to load image: images/${card.image}')"><br>
        <strong>${card.name}</strong><br>
        <em>${card.rarity}</em><br>
        ${card.amount ? `x${card.amount}` : ""}
      `;
      cardsDiv.appendChild(div);
    });

    packDiv.classList.remove("hidden");
    document.body.classList.add("ui-active");
  }

  if (data.action === "notify") {
    const nBox = document.getElementById("notifications");
    if (!nBox) return;
    const div = document.createElement("div");
    div.className = `notification ${data.nType || ""}`;
    div.textContent = data.text || "";
    nBox.appendChild(div);
    setTimeout(() => div.remove(), 4000);
  }

  if (data.action === "showCollection") {
    // Ensure pack interface is closed
    const packResult = document.getElementById("pack-result");
    if (packResult && !packResult.classList.contains("hidden")) {
      packResult.classList.add("hidden");
    }

    const collectionDiv = document.getElementById("collection");
    if (!collectionDiv) return;

    currentCollection = data.cards || [];
    renderCollection();
    collectionDiv.classList.remove("hidden");
    document.body.classList.add("ui-active");
  }
});

// ===== Close helpers (NUI safe) =====
function closePackInterface() {
  const packResult = document.getElementById("pack-result");
  if (packResult) packResult.classList.add("hidden");
  document.body.classList.remove("ui-active");

  // Post back to client if available
  try {
    const resName = (typeof GetParentResourceName === "function") ? GetParentResourceName() : null;
    if (resName) {
      fetch(`https://${resName}/closeUI`, { method: "POST" });
    }
  } catch (_e) {
    // ignore when not in NUI
  }
}

function closeCollection() {
  const collection = document.getElementById("collection");
  const packResult = document.getElementById("pack-result");

  if (collection) collection.classList.add("hidden");
  if (packResult) packResult.classList.add("hidden");
  document.body.classList.remove("ui-active");

  try {
    const resName = (typeof GetParentResourceName === "function") ? GetParentResourceName() : null;
    if (resName) {
      fetch(`https://${resName}/closeUI`, { method: "POST" });
    }
  } catch (_e) {}
}

// ===== Global key / click listeners =====
document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
    const packResult = document.getElementById("pack-result");
    const collection = document.getElementById("collection");

    if (packResult && !packResult.classList.contains("hidden")) {
      closePackInterface();
    } else if (collection && !collection.classList.contains("hidden")) {
      closeCollection();
    }
  }
});

// Click background to close overlays when clicking directly on them
document.addEventListener("click", function (event) {
  const packResult = document.getElementById("pack-result");
  const collection = document.getElementById("collection");

  if (packResult && !packResult.classList.contains("hidden") && event.target === packResult) {
    closePackInterface();
  }
  if (collection && !collection.classList.contains("hidden") && event.target === collection) {
    closeCollection();
  }
});

// ===== Init (bind AFTER DOM is ready) =====
document.addEventListener("DOMContentLoaded", function () {
  // Start hidden
  const packResult = document.getElementById("pack-result");
  const collection = document.getElementById("collection");
  if (packResult) packResult.classList.add("hidden");
  if (collection) collection.classList.add("hidden");
  document.body.classList.remove("ui-active");

  // Controls
  const filterElement = document.getElementById("filter");
  const sortElement = document.getElementById("sort");
  const closeBtn = document.getElementById("close-btn");

  if (closeBtn) closeBtn.addEventListener("click", closePackInterface);

  if (filterElement) {
    filterElement.addEventListener("change", () => {
      renderCollection(filterElement.value, sortElement ? sortElement.value : "name");
    });
  }

  if (sortElement) {
    sortElement.addEventListener("change", () => {
      renderCollection(filterElement ? filterElement.value : "", sortElement.value);
    });
  }
});
