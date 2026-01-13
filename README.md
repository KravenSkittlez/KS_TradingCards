---

# KS Trading Cards

A FiveM resource that adds **collectible trading cards**, **pack opening**, **player collections**, and an in-game **UI** with sorting, filtering, and search.
Built for **oxmysql** and integrates with **QBCore**.

---

## 📦 Features

* Weighted rarity system with configurable odds.
* Two sample packs (`Standard` and `Premium`) with guaranteed rarities.
* Persistent player **collection** and **inventory** (MySQL).
* NUI interface to:

  * View pack opening results.
  * Browse your full collection.
  * Filter by rarity, sort, and search by name.
* Optional admin/debug commands and live odds editing.
* Simple structure for adding new cards, packs, and images.

---

## 🗂 Folder Structure

```
ks_tradingcards/
│  fxmanifest.lua
│  config.lua                -- Master config for cards/packs/odds
│
├─client/
│    client.lua              -- NUI bridge & commands
│
├─server/
│    server.lua              -- Core logic & DB operations
│    ks_debug.lua            -- Debug/admin tools (optional)
│
├─html/                      -- NUI web app
│    index.html
│    style.css
│    script.js
│    images/                 -- Place card images here
│
└─sql/
     ks_tradingcards.sql     -- Database schema
     ks_items.sql            -- Legacy ox_inventory items (deprecated)
     qbcore_items.lua        -- QBCore items format
```

---

## ⚡ Installation

1. **Database**

   * Import `sql/ks_tradingcards.sql` to create the collection/inventory tables.

2. **Items Setup**

   * Copy the items from `sql/qbcore_items.lua` and add them to your `qb-core/shared/items.lua` file.
   * Make sure to add the item images to your inventory resource's images folder.

3. **Dependencies**

   * [oxmysql](https://github.com/overextended/oxmysql)
   * [qb-core](https://github.com/qbcore-framework/qb-core)

3. **Resource**

   * Place the folder in your server’s `resources/` directory.
   * Ensure it in your `server.cfg`:

     ```
     ensure ks_tradingcards
     ```

4. **Images (optional)**

   * Put PNG/JPG files in `html/images/` and include in `fxmanifest.lua`:

     ```lua
     files {
         'html/index.html',
         'html/style.css',
         'html/script.js',
         'html/images/*.png'
     }
     ```

---

## ⚙️ Configuration (`config.lua`)

* **Rarity Odds**

  ```lua
  Config.RarityOdds = {
      Common = 65.0,
      Rare = 25.0,
      Epic = 7.0,
      Legendary = 2.5,
      Mythic = 0.5,
  }
  ```

* **Cards**

  ```lua
  Config.Cards = {
      { id = 1, name = "Michael De Santa", rarity = "Common", image = "michael.png" },
      { id = 2, name = "Franklin Clinton", rarity = "Common", image = "franklin.png" },
      ...
  }
  ```

  *`image` is optional but recommended for NUI display.*

* **Packs**

  ```lua
  Config.Packs = {
      {
          pack_id = "standard",
          name = "Standard Pack",
          cost = 1000,
          contents = { total = 5, guaranteedCount = 1, guaranteedAtLeast = "Rare" }
      },
      ...
  }
  ```

* **Debug Flags**

  ```lua
  Config.Debug = false          -- Enables in-game admin debug commands
  Config.EnableDebugFile = true -- Loads ks_debug.lua if true
  ```

---

## 🖼 Adding New Cards

1. **Image**
   Place the PNG/JPG in `html/images/` (or use a full URL).

2. **Config Entry**
   Add a new record to `Config.Cards`:

   ```lua
   { id = 6, name = "Chop", rarity = "Rare", image = "chop.png" },
   ```

3. **Database Item (optional)**
   If using ox\_inventory and you want each card as an item:

   ```sql
   INSERT INTO items (name, label, weight, stack, closeonuse, description)
   VALUES ('card_6', 'Chop (Rare)', 1, 100, 0, 'Trading Card');
   ```

4. **fxmanifest.lua**
   Make sure `html/images/*.png` is included in the `files` list.

---

## 🎮 Player Usage

* **Open a Pack**
  *If using ox\_inventory:* use the pack item (`pack_standard`, `pack_premium`).

* **View Collection**
  `/mycards` — Shows NUI with owned cards.

* **UI Controls**

  * Search by name.
  * Filter by rarity.
  * Sort by Name, Rarity, or Amount.

---

## 🛠 Admin / Debug Commands

*(Require `Config.EnableDebugFile = true`; in-game commands also need `Config.Debug = true`)*

| Command                       | Description                                     |
| ----------------------------- | ----------------------------------------------- |
| `/showodds`                   | Print current rarity odds.                      |
| `/setodds [rarity] [percent]` | Adjust odds live.                               |
| `/saveodds`                   | Save odds to `data/odds.json`.                  |
| `/resetodds`                  | Reset odds to defaults.                         |
| `/debugcards`                 | List all configured cards.                      |
| `/debugpacks`                 | List all configured packs.                      |
| `/testdrop [packId] [runs]`   | Simulate openings and show rarity distribution. |

Console can always use these commands; in-game requires `Config.Debug = true`.

---

## 🚀 Tips

* **Hot-Reload**: `restart ks_tradingcards` after editing `config.lua` or adding images.
* **Images via URL**: Set `image` to a full `https://` link if you prefer not to ship files.
* **Extending Packs**: Add more packs with unique `pack_id` and adjust guaranteed rarities as needed.

---

Enjoy collecting and trading! 🎴

---