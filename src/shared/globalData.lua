return {
    DATA_VERSION = "v001",
    GAME_VERSION = "v0.1",

    DEFAULT_DATA = {
        receipts = {};

        character = {
            lastName = "";
            clothing = 1;
            skinTone = 1;
            face = "";

            headAccessory = 0;
            bodyAccessory = 0;
            hairColor = {
                r = 0;
                g = 0;
                b = 0;
            }
        },

        stats = {
            physicalStrength = 1;
            control = 1;

            endurance = 1;
            speed = 1;
            stamina = 1;
        },

        generation = 1; -- Defailt is "Unknown"
        combatTechnique = "Hobo"; -- Default is "Hobo"
        combatEXP = 0; -- Re-roll generation and technique when reached certain exp, also lock re-rolling in menu

        faction = 0; --    0 = factionless    1 = Fire Force   2 = White Clad    3 = Church
        reputation = 0;
        rank = "";

        yen = 0,
        techniqueSpins = 0,
        generationSpins = 0,
        faceSpins = 0,

        options = {
            music = 1;
            sfx = 1;
            ui = 1;
        },
    }
}