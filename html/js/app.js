// UI Controller (MI visuals, KS protocol)
// - Accepts KS NUI messages: { action: 'showPackResult' | 'showCollection' | 'notify', ... }
// - Keeps MI/Vue visual components

function getResourceNameSafe() {
  try {
    if (typeof GetParentResourceName === 'function') return GetParentResourceName();
  } catch (_e) {}
  return null;
}

function nuiPost(endpoint, payload) {
  const resName = getResourceNameSafe();
  if (!resName) return Promise.resolve();
  return fetch(`https://${resName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(payload || {})
  }).catch(() => {});
}

function colorsForRarity(rarity) {
  const r = (rarity || '').toLowerCase();

  // Default "basic" palette
  const base = {
    color1: '#ffffff',
    color2: '#f2f2f2',
    color3: '#ffffff',
    color4: '#eaeaea',
    border_size: 6,
    border_color: '#9a9a9a',
    shining: false,
    sparkles: false,
    bg_images: null,
  };

  if (r === 'common') {
    return { ...base, border_color: '#8f8f8f', sparkles: false };
  }
  if (r === 'uncommon') {
    return { ...base, border_color: '#2f9e44', sparkles: true };
  }
  if (r === 'rare') {
    return { ...base, border_color: '#1c7ed6', sparkles: true };
  }
  if (r === 'epic') {
    return { ...base, border_color: '#9c36b5', sparkles: true, shining: true };
  }
  if (r === 'legendary') {
    return { ...base, border_color: '#f59f00', sparkles: true, shining: true };
  }
  if (r === 'mythic') {
    return { ...base, border_color: '#e03131', sparkles: true, shining: true };
  }

  return base;
}

function mapKsCardToUi(card, flipDefault) {
  const img = card?.image ? `img/${card.image}` : '';
  const rarity = card?.rarity || '';
  const amount = card?.amount != null ? `Owned: x${card.amount}` : '';

  return {
    rank: (rarity || 'basic').toLowerCase(),
    withCase: false,
    label: card?.name || 'Unknown',
    health: '',
    images: img,
    description: amount,
    term: rarity,
    attack: '',
    icon: '',
    isFliped: !!flipDefault,
    colors: colorsForRarity(rarity),
  };
}

window.APP = {
  template: '#app_template',
  name: 'app',
  data() {
    return {
      cards: [],
      displayOpenAnother: false,
      displayOpenInventory: false,
      displayClose: false,
      remain: 0,
      isShow: false,
      lastMode: null, // 'pack' | 'collection'
    };
  },
  destroyed() {
    window.removeEventListener('message', this.listener);
    window.removeEventListener('keyup', this.EVENT_KEYPRESS);
  },
  mounted() {
    this.listener = window.addEventListener('message', (event) => {
      const item = event.data || event.detail;
      if (!item) return;

      // --- KS protocol ---
      if (item.action) {
        if (item.action === 'showPackResult') {
          this.SHOW_PACK_RESULT(item);
          return;
        }
        if (item.action === 'showCollection') {
          this.SHOW_COLLECTION(item);
          return;
        }
        if (item.action === 'notify') {
          this.NOTIFY(item);
          return;
        }
      }

      // --- Legacy MI protocol (kept for compatibility) ---
      if (item.type && this[item.type]) {
        this[item.type](item);
      }
    });

    window.addEventListener('keyup', this.EVENT_KEYPRESS);
  },
  methods: {
    // ===== KS handlers =====
    SHOW_PACK_RESULT(item) {
      document.body.style.display = 'block';
      this.lastMode = 'pack';
      this.isShow = true;
      this.cards = (item.cards || []).map(c => mapKsCardToUi(c, false));
      this.displayClose = true;
      this.displayOpenInventory = false;
      this.displayOpenAnother = false;
    },

    SHOW_COLLECTION(item) {
      document.body.style.display = 'block';
      this.lastMode = 'collection';
      this.isShow = true;
      this.cards = (item.cards || []).map(c => mapKsCardToUi(c, true));
      this.displayClose = true;
      this.displayOpenInventory = false;
      this.displayOpenAnother = false;
    },

    NOTIFY(item) {
      // Minimal toast — stays non-blocking
      const text = item.text || '';
      if (!text) return;

      const toast = document.createElement('div');
      toast.className = `ks-toast ${item.nType || ''}`;
      toast.textContent = text;
      document.body.appendChild(toast);

      setTimeout(() => toast.classList.add('show'), 10);
      setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 250);
      }, 3500);
    },

    // ===== Legacy MI methods (unchanged but disabled buttons) =====
    ON_OPEN() {
      this.isShow = false;
      this.cards = [];
    },
    ON_ADD_CARDS(item) {
      this.cards = item.cards || [];
      // Disable MI-specific buttons in KS mode
      this.displayOpenAnother = false;
      this.displayOpenInventory = false;
      this.displayClose = true;
    },
    ON_CLOSE() {
      this.cards = [];
    },
    ON_SHOW_CARD(item) {
      this.isShow = true;
      this.cards = [item.card];
      this.displayClose = true;
      this.displayOpenInventory = false;
      this.displayOpenAnother = false;
    },

    EVENT_KEYPRESS(event) {
      if (!this.isShow) return;
      if (event.which === 27) {
        this.close();
      }
    },

    /* Button Methods */
    openAnother() {
      // Not used for KS
    },
    openInventory() {
      // Not used for KS
    },
    close() {
      document.body.style.display = 'none';
      this.isShow = false;
      this.cards = [];
      this.displayClose = false;
      this.displayOpenInventory = false;
      this.displayOpenAnother = false;
      nuiPost('closeUI', {});
    }
  },
};
