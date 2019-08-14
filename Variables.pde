JSONObject json;

App app;
Capture cam;
Client myClient; 
Server myServer;
SoundFile hit,miss;
VideoExport videoExport;
Logger logger;
LogHelper loghelper;
CaptureFrame thread;

StringDict postureMap;
enum WiggleMode { INC, DEC};
HashMap<String,PImage> iconSet;
int[] codes;
Boolean verbose,recordVideo,taskStarted,isFirst,gameoverflag;
int numBlocks, numSequences, numTrials, taskSpeed, postureTimer, dataIn, PORT;
String participantId, experimentId, modeId, wordBeingTyped, startTime, identifiedPosture, experimentStartTime, experimentEndTime, blockStartTime, blockEndTime, setStartTime, setEndTime, targetStartTime, targetEndTime, HOST;
String[][][] taskOrders, practiceOrder, experimentOrder;
String[] shortcuts, modifierkeys, words, postures, two_hand_postures;

  
void initVariables(){
  json = loadJSONObject("variables.json");
  HOST= json.getString("host");
  PORT= json.getInt("port");
  participantId = json.getString("participant_id");
  experimentId = json.getString("experiment_id"); //one/two
  modeId = json.getString("mode_id");// practice/experiment
  taskSpeed = 6;//json.getInt("task_speed");
  postureTimer = 6000;//json.getInt("task_speed"); 
  verbose = json.getBoolean("verbose");//false;// log video frame events
  
  wordBeingTyped="";
  recordVideo=false;
  taskStarted=false; //<>// //<>//
  identifiedPosture="";
  isFirst=true;
  gameoverflag=false;

  iconSet = new HashMap<String,PImage>();
  
  shortcuts= new String[]{"left", "up", "right", "down", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
  codes= new int[]{37, 38, 39, 40, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90}; 
  modifierkeys= new String[]{"Option", "Ctrl", "Shift"};

  words =new String[] {"power", "radio", "alley", "Throw", "going", "who's", "Hedda", "sky's", "Timon", "found", "bulky", "locks", "peace", "young", "Their", "cover", "Luisa", "child", "after", "value", "Bucer", "cared", "mania", "stoop", "While", "ahead", "acted", "depot", "enemy", "sixty", "irons", "await", "named", "asses", "fleck", "trust", "safer", "bleak", "irony", "paths", "grows", "ideal", "curly", "Staff", "Labor", "honor", "White", "walls", "novel", "banks", "House", "woods", "state", "Eli's", "likes", "upset", "Walsh", "dress", "She'd", "Greek", "Scout", "piled", "merit", "grown", "Uncle", "towns", "Along", "carts", "abbot", "edges", "liked", "scrub", "while", "spend", "Music", "fifty", "kinds", "three", "barge", "meant", "lovin", "eager", "Payne", "civic", "You'd", "noted", "style", "lulls", "Whigs", "tears", "event", "tract", "fires", "calls", "Fists", "niche", "roofs", "Which", "eased", "Still", "queer", "moral", "cluck", "added", "beans", "smoke", "month", "bathe", "bully", "fight", "Anita", "abbey", "Creek", "weary", "greet", "Booth", "hover", "fears", "dimly", "today", "faces", "lover", "faded", "Odilo", "Offer", "Clara", "linen", "Fetch", "Lemme", "pulls", "stock", "shore", "dusty", "bosom", "older", "Dover", "sails", "horns", "chick", "wires", "cloud", "fried", "rocks", "Burly", "start", "stand", "plump", "rider", "below", "glory", "drown", "stuff", "Dirty", "wired", "drift", "clock", "drunk", "Poles", "he'll", "grunt", "laden", "shaft", "night", "label", "slits", "gleam", "tired", "signs", "naked", "birth", "How's", "phone", "rites", "breed", "Pieta", "glass", "cards", "twist", "C'est", "games", "shape", "shone", "coast", "Sound", "gonna", "enter", "alive", "crack", "Abbot", "favor", "harem", "voice", "hens'", "image", "Maria", "stool", "words", "Elder", "fiery", "could", "paced", "sober", "Isaac", "shock", "close", "knoll", "sides", "traps", "jaded", "Swiss", "sorry", "court", "Quick", "chose", "faith", "bride", "there", "dog's", "suits", "tools", "aisle", "pains", "Early", "waded", "amuse", "serve", "winds", "choke", "freed", "Blois", "wrote", "quick", "minds", "touch", "fling", "lousy", "wages", "broke", "grate", "ruler", "fists", "shrub", "Byron", "cleat", "taken", "speck", "agree", "Leona", "ivory", "idols", "clips", "bills", "tough", "color", "teeth", "dream", "watch", "flung", "lusty", "sheer", "plays", "thorn", "catch", "balls", "ships", "paint", "halos", "razor", "Drury", "panic", "loved", "shall", "packs", "clung", "cleft", "weeks", "Drunk", "abyss", "rails", "Going", "essay", "gowns", "belch", "Hired", "you'd", "Later", "Judea", "brush", "leave", "split", "Fifth", "movie", "given", "Tours", "pique", "drops", "devil", "flare", "relax", "one's", "hopes", "grand", "bells", "wrist", "geese", "death", "Order", "known", "front", "spume", "Water", "lance", "torso", "guest", "Favre", "vogue", "Souci", "views", "Eliot", "maybe", "crept", "beach", "royal", "swell", "beset", "slept", "South", "wails", "wheel", "clerk", "Ferry", "first", "tight", "other", "sight", "wiped", "robed", "Leave", "beech", "quite", "we're", "drier", "bowed", "Debts", "gusto", "lying", "fence", "maids", "guilt", "Lousy", "scope", "hurry", "Joe's", "Maybe", "usual", "plate", "day's", "Italy", "print", "oddly", "cuffs", "frees", "begun", "mourn", "exile", "frail", "agent", "prove", "skirt", "stood", "sushi", "chain", "Derby", "folks", "sighs", "Annie", "haunt", "along", "right", "spell", "quart", "blade", "chest", "porch", "midst", "takes", "times", "daunt", "shook", "Mines", "piano", "loyal", "Pat's", "drank", "Lying", "strut", "waist", "smelt", "folds", "judge", "manor", "aware", "swept", "would", "plush", "meals", "let's", "hafta", "gauge", "flick", "Times", "magic", "might", "begin", "plant", "horse", "brand", "son's", "level", "basin", "Saint", "After", "Lippi", "humor", "flour", "buddy", "stove", "Melzi", "sleep", "sizes", "Marsh", "pilot", "Astor", "Those", "patch", "sends", "blood", "links", "aloof", "isn't", "Frank", "tempt", "giant", "Never", "shift", "hinge", "flies", "chief", "these", "doing", "stern", "Craig", "chafe", "awful", "Anger", "caved", "write", "range", "Above", "model", "index", "serge", "Under", "reach", "Texas", "halls", "funny", "worry", "ready", "boats", "knack", "takin", "Fixed", "ports", "Yooee", "Gouge", "booth", "point", "Sixty", "rapid", "goose", "mouth", "short", "baths", "notes", "Tears", "misty", "sweat", "eaten", "We'll", "untie", "Davao", "build", "waved", "sofas", "think", "fancy", "cares", "terms", "myrrh", "ruled", "David", "album", "Scrub", "fired", "Won't", "Jorge", "argue", "shade", "Gogol", "Edwin", "vague", "march", "Ain't", "Hotel", "Below", "bring", "tango", "raced", "howls", "stray", "Laura", "choir", "steak", "paled", "bacon", "gasps", "store", "raged", "Verdi", "March", "human", "blink", "aside", "allow", "angry", "forms", "spike", "brink", "spare", "wanta", "still", "Irvin", "inane", "gaily", "groin", "hired", "throw", "jerky", "paces", "moved", "tries", "skulk", "ashen", "least", "songs", "saved", "flats", "paper", "again", "cages", "cents", "inert", "south", "Lovie", "trash", "prize", "haste", "Knows", "tenth", "party", "press", "hoops", "wrack", "scale", "knows", "Tolek", "mercy", "Enjoy", "merge", "loins", "lucky", "sound", "Styka", "broad", "Metro", "niece", "Corne", "skies", "wring", "out'n", "brave", "heavy", "eight", "kid's", "Linda", "goals", "blame", "works", "Grove", "Dimes", "ROK's", "metal", "crime", "flood", "exist", "aloud", "order", "robes", "alert", "stuck", "guard", "Cycly", "silky", "fifth", "lawns", "track", "check", "cling", "coals", "loves", "miles", "score", "wrath", "doubt", "burst", "swung", "hotel", "weeds", "spire", "comes", "speak", "bunch", "C'mon", "cruel", "shake", "Duane", "cause", "beard", "rabbi", "wakes", "wines", "scrap", "Sheer", "wryly", "bench", "Place", "cough", "glued", "Muses", "Among", "heads", "spite", "stage", "Union", "Human", "Santa", "tepid", "grace", "charm", "wanna", "Flies", "shack", "shame", "fetid", "title", "barns", "rowed", "Light", "share", "lines", "sneer", "lemon", "trees", "fault", "Fanny", "bower", "queen", "berry", "drove", "anger", "teach", "Gre't", "tales", "plots", "gaunt", "husky", "scent", "asked", "glare", "tubes", "gummy", "Katie", "sired", "peaks", "light", "Would", "Ecole", "Corps", "It'll", "flame", "keeps", "crawl", "dirty", "silly", "North", "slope", "clump", "creep", "Today", "Wised", "items", "grief", "leaps", "rigid", "earth", "topic", "stick", "worst", "Devil", "panes", "alien", "brown", "slack", "story", "quiet", "deals", "boy's", "slice", "ought", "purse", "Irish", "round", "Husky", "pouch", "apple", "draws", "whirl", "honey", "noble", "bones", "spill", "stare", "lamps", "brain", "built", "Chief", "stars", "waxed", "sheaf", "fumes", "teens", "china", "quill", "Allen", "place", "plank", "bunks", "Krist", "haint", "until", "began", "flops", "hound", "crash", "pokes", "trace", "Black", "years", "faint", "shoes", "Funny", "surge", "juicy", "curse", "doves", "white", "enact", "Three", "cagey", "chase", "their", "filed", "guess", "shirt", "weirs", "imply", "holds", "Santo", "she'd", "waste", "rural", "spots", "drawl", "bored", "needs", "Heart", "Again", "Since", "flint", "Y'all", "weigh", "plied", "chaos", "shyly", "badly", "trips", "voted", "never", "Major", "using", "flock", "anvil", "Gonna", "toast", "hated", "froze", "crude", "vivid", "steel", "elfin", "cried", "Stick", "large", "knife", "chops", "blind", "storm", "drive", "decry", "weird", "crest", "Front", "carry", "Bible", "Ching", "crook", "alors", "stiff", "eagle", "bluff", "Can't", "tweed", "There", "inter", "edged", "Royal", "pages", "snail", "sadly", "Could", "hoist", "treat", "gloom", "whole", "sharp", "Siege", "sword", "Let's", "palms", "cigar", "opera", "attic", "lunch", "hen's", "can't", "inept", "Mavis", "reins", "Tokyo", "nymph", "strip", "furor", "don't", "bloom", "visit", "shout", "Tiber", "yours", "tying", "house", "skill", "grasp", "faced", "facts", "labor", "smell", "ankle", "sun's", "spark", "crags", "hulks", "angel", "homes", "rifle", "hints", "farms", "lived", "flash", "growl", "avoid", "coats", "seems", "silos", "Macon", "twice", "shoot", "woman", "hoped", "Stand", "limit", "every", "awake", "rasps", "lives", "clear", "great", "rules", "trial", "Chris", "About", "angle", "regal", "birds", "scant", "waves", "north", "brass", "Aggie", "shawl", "files", "where", "Dives", "books", "women", "Right", "tiled", "buggy", "piece", "speed", "Brook", "grass", "trade", "thing", "sayin", "early", "saint", "tryin", "group", "offer", "straw", "veils", "dingy", "Ahead", "towel", "we'll", "brick", "borne", "Cheat", "Bobby", "daily", "reply", "sense", "cloth", "green", "corps", "undid", "leash", "clean", "Plans", "Dutch", "Whole", "mount", "doors", "flail", "ridge", "dozen", "Cheap", "dying", "She's", "upper", "fused", "petit", "yield", "solid", "hours", "baton", "yards", "obeys", "poems", "Grimm", "enjoy", "souls", "turns", "ended", "casts", "risen", "bulge", "nerve", "rolls", "pupil", "mewed", "Sally", "James", "Cover", "tells", "Billy", "wings", "showy", "bread", "hasps", "ranks", "Don't", "Louis", "budge", "wound", "backs", "sugar", "ached", "chute", "cross", "Rebel", "happy", "cavin", "money", "suite", "valet", "slide", "jelly", "ducks", "black", "swing", "hairy", "ideas", "crows", "staff", "local", "opens", "pumps", "Canal", "sweep", "Giles", "Ludie", "Cried", "drink", "stone", "fever", "lists", "riven", "under", "Paris", "We've", "field", "elder", "eared", "later", "spent", "Great", "vocal", "pasty", "creek", "poked", "rooms", "alter", "pride", "girls", "worse", "moist", "third", "We're", "fuzzy", "gaudy", "youth", "widow", "being", "since", "cheer", "wagon", "shown", "Honor", "stump", "uncle", "basis", "proud", "truth", "which", "herbs", "crank", "Seems", "Jim's", "foyer", "hunch", "bugle", "dared", "Peter", "Fresh", "Henry", "dough", "smirk", "smart", "Slice", "hills", "vital", "blast", "spoke", "tried", "logic", "dates", "China", "sworn", "block", "Trust", "plans", "squad", "fille", "notch", "board", "comin", "occur", "count", "privy", "frame", "entry", "knock", "fixed", "boots", "skull", "admit", "clams", "final", "water", "inner", "raise", "Rumor", "Medal", "belly", "lands", "uh-uh", "Clean", "forth", "cases", "equal", "rides", "God's", "Jesus", "means", "hairs", "mines", "Ada's", "boxes", "learn", "sloop", "erect", "fully", "camps", "scarf", "lairs", "Aaron", "laugh", "couch", "Sleep", "pause", "shops", "shred", "River", "pants", "lanky", "apron", "dance", "Queen", "world", "holes", "major", "noise", "Young", "drawn", "cheek", "lined", "guide", "Rabbi", "shave", "tumor", "slave", "hands", "Brown", "olive", "crowd", "rocky", "Alone", "cat's", "knees", "flesh", "falls", "roads", "swirl", "knelt", "Every", "dirge", "worth", "spray", "parts", "drama", "gates", "H'all", "Chiba", "lower", "cream", "civil", "colts", "Board", "Abbey", "Sloan", "Where", "sized", "plain", "Keene", "handy", "owner", "snake", "steps", "tower", "slums", "small", "exact", "truce", "booby", "stole", "Until", "scuff", "makes", "craft", "study", "tread", "force", "heart", "slate", "dried", "Roman", "awoke", "Simms", "Yehhh", "Opera", "Ethel", "sixth", "scene", "climb", "shied", "forty", "fresh", "mooed", "Faint", "rough", "alone", "lungs", "prick", "rowdy", "cheap", "chair", "frise", "won't", "muddy", "train", "theme", "acres", "crazy", "Solid", "Rifle", "muted", "peril", "urged", "'nuff", "among", "First", "wedge", "Seven", "beams", "fiend", "loose", "poles", "spies", "Civil", "sulky", "Venus", "sweet", "bonds", "groom", "whose", "extra", "Bosch", "shove", "owl's", "she's", "ain't", "These", "April", "roast", "Sands", "He'll", "class", "threw", "State", "brief", "merry", "disks", "looks", "break", "often", "aloes", "Point", "gross", "Harry", "river", "sandy", "bulks", "wants", "outer", "seven", "tones", "waked", "floor", "wares", "steal", "gives", "table", "harpy", "Maple", "nails", "dumps", "dined", "who'd", "stall", "truly", "focal", "gangs", "alarm", "puppy", "thick", "skiff", "unwed", "perch", "focus", "colds", "above", "man's", "music", "heard", "names", "spoon", "Leale", "genre", "gazed", "leapt", "chord", "empty", "about", "smile", "those", "coils", "wrong", "beast", "Izaak"};

  two_hand_postures = new String[]{
                          "Both_Close_0_On","Both_Close_90_On", "Both_Close_180_On", "Both_Open_0_On", "Both_Open_90_On", "Both_Open_180_On",
                          "Both_Close_0_Below","Both_Close_90_Below", "Both_Close_180_Below", "Both_Open_0_Below", "Both_Open_90_Below", "Both_Open_180_Below",
                          "Both_Close_0_Beside", "Both_Close_90_Beside", "Both_Close_180_Beside", "Both_Open_0_Beside", "Both_Open_90_Beside", "Both_Open_180_Beside",
                          };
  postures = new String[]{
    "Left_Close_0_On",//};
    "Left_Close_0_Below", "Left_Close_0_Beside", "Left_Close_90_On", "Left_Close_90_Below", "Left_Close_90_Beside", "Left_Close_180_On", "Left_Close_180_Below", "Left_Close_180_Beside",
    "Left_Open_0_On","Left_Open_0_Below", "Left_Open_0_Beside", "Left_Open_90_On", "Left_Open_90_Below", "Left_Open_90_Beside", "Left_Open_180_On", "Left_Open_180_Below", "Left_Open_180_Beside",
    "Right_Close_0_On","Right_Close_0_Below", "Right_Close_0_Beside", "Right_Close_90_On", "Right_Close_90_Below", "Right_Close_90_Beside", "Right_Close_180_On", "Right_Close_180_Below", "Right_Close_180_Beside",
    "Right_Open_0_On","Right_Open_0_Below", "Right_Open_0_Beside", "Right_Open_90_On", "Right_Open_90_Below", "Right_Open_90_Beside", "Right_Open_180_On", "Right_Open_180_Below", "Right_Open_180_Beside"
  };

  
  practiceOrder = new String[][][]{
                               {
                                  //{"word"}
                                   {"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},
                                   {"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},
                                   {"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"},{"two_hand_posture"}
                                }
                             };

  experimentOrder= new String[][][]{
                                  {
                                   {"word","posture"}, {"shortcut","posture"}, {"click","posture"}, {"word","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"}
                                  }, 
                                  {
                                   {"word","posture"}, {"shortcut","posture"}, {"click","posture"}, {"word","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"}
                                  }, 
                                  {
                                   {"word","posture"}, {"shortcut","posture"}, {"click","posture"}, {"word","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"}
                                  }
                                };
  
  taskOrders = (modeId.equals("practice"))?practiceOrder:experimentOrder;
  numBlocks = taskOrders.length;
  numSequences = taskOrders[0].length;
  numTrials = taskOrders[0][0].length;

}
