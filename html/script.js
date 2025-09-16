let currentCollection = [];

function renderCollection() {
    const rarityFilter = document.getElementById("filter-rarity").value;
    const sortBy = document.getElementById("sort-by").value;
    const search = document.getElementById("search-name").value.toLowerCase();

    let filtered = currentCollection;

    if (rarityFilter !== "all") {
        filtered = filtered.filter(c => c.rarity === rarityFilter);
    }
    if (search) {
        filtered = filtered.filter(c => c.name.toLowerCase().includes(search));
    }
    if (sortBy === "name") {
        filtered.sort((a, b) => a.name.localeCompare(b.name));
    } else if (sortBy === "rarity") {
        filtered.sort((a, b) => a.rarity.localeCompare(b.rarity));
    } else if (sortBy === "amount") {
        filtered.sort((a, b) => b.amount - a.amount);
    }

    const cardsDiv = document.getElementById("cards");
    cardsDiv.innerHTML = "";
    filtered.forEach(card => {
        const div = document.createElement("div");
        div.className = "card";
        div.innerHTML = `<strong>${card.name}</strong><br><em>${card.rarity}</em><br>x${card.amount}`;
        cardsDiv.appendChild(div);
    });
}

window.addEventListener("message", function(event) {
    const data = event.data;
    if (data.action === "showPackResult") {
        const packDiv = document.getElementById("pack-result");
        const cardsDiv = document.getElementById("cards");
        const title = document.getElementById("pack-title");
        title.textContent = `You opened a ${data.pack.name}!`;
        cardsDiv.innerHTML = "";
        data.cards.forEach(card => {
            const div = document.createElement("div");
            div.className = "card";
            div.innerHTML = `
             <img src="images/${card.image}" class="card-img"><br>
             <strong>${card.name}</strong><br>
             <em>${card.rarity}</em><br>
             x${card.amount || ''}
            `;
            cardsDiv.appendChild(div);
        });
        packDiv.classList.remove("hidden");
    }
    if (data.action === "notify") {
        const nBox = document.getElementById("notifications");
        const div = document.createElement("div");
        div.className = `notification ${data.nType}`;
        div.textContent = data.text;
        nBox.appendChild(div);
        setTimeout(() => div.remove(), 4000);
    }
    if (data.action === "showCollection") {
        const packDiv = document.getElementById("pack-result");
        const title = document.getElementById("pack-title");
        title.textContent = "Your Collection";
        currentCollection = data.cards;
        document.getElementById("collection-controls").classList.remove("hidden");
        renderCollection();
        packDiv.classList.remove("hidden");
    }
});

document.getElementById("close-btn").addEventListener("click", () => {
    document.getElementById("pack-result").classList.add("hidden");
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: "POST" });
});

document.getElementById("filter-rarity").addEventListener("change", renderCollection);
document.getElementById("sort-by").addEventListener("change", renderCollection);
document.getElementById("search-name").addEventListener("input", renderCollection);
