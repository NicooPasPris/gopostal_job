Config              = {}
Config.DrawDistance = 100.0
Config.Locale       = 'fr'

Config.JobVehiclePlate = 'GOPOSTAL' -- Plaque des vehicules du job (maximun 8 caractères)
Config.MaxLetter	   = 4 -- Maximum de lettre par point
Config.MinLetter	   = 1 -- Maximum de lettre par point
Config.MaxColis		   = 2 -- Maximum de colis par point
Config.MinColis		   = 0 -- Maximum de colis par point

Config.Caution 		   = 2000
Config.PricePerLetter  = 7
Config.PricePerColis   = 15

Config.Vehicle = { -- Ajouter les véhicules du métier ici
	"boxville2"
}

Config.Zones = { -- Emplacement des points
	CloakRoom = {
		Pos   = {x = 78.899, y = 111.934, z = 80.1},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 231, g = 76, b = 60},
		Type  = 1
	},

	VehicleSpawner = {
		Pos   = {x = 69.0792, y = 125.886, z = 78.1},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 142, g = 68, b = 173},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos     = {x = 66.232, y = 121.310, z = 79.112},
		Heading = 160.0, -- Orientation 
		Size    = {x = 3.0, y = 3.0, z = 1.0},
		Type    = -1
	},

	VehicleDeleter = {
		Pos   = {x = 79.134, y = 88.883, z = 77.6},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 142, g = 68, b = 173},
		Type  = 1
	},

	Distribution = { -- point pr récuperer les colis & courrier
		Pos   = {x = 115.141, y = 100.649, z = 79.890},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 236, g = 240, b = 241},
		Type  = 1
	},
}

Config.Uniforms = { -- Tenue de service
	
	male = {
		['tshirt_1'] = 57,  ['tshirt_2'] = 0,
		['torso_1'] = 13,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 11,
		['pants_1'] = 10,   ['pants_2'] = 2,
		['shoes_1'] = 54,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 12,    ['chain_2'] = 2,
		['ears_1'] = -1,     ['ears_2'] = 0
	},
	female = {
		['tshirt_1'] = 34,  ['tshirt_2'] = 0,
		['torso_1'] = 9,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 9,
		['pants_1'] = 6,   ['pants_2'] = 2,
		['shoes_1'] = 52,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 2,
		['ears_1'] = -1,     ['ears_2'] = 0
	}
}


-- Point des livraisons

Config.Livraisons = {
	Richman = {
		Pos = {
			{x = -1129.1517, y = 395.020, z = 69.651, letter = true, colis = false},
			{x = -1103.568, y = 284.569, z = 63.094, letter = true, colis = false},
			{x = -1473.558, y = -10.789, z = 54.525, letter = true, colis = false},
			{x = -1532.2011, y = -37.736, z = 56.381, letter = true, colis = false},
			{x = -1545.794, y = -33.281, z = 56.891, letter = true, colis = false},
			{x = -1464.423, y = 51.018, z = 53.988, letter = true, colis = false},
			{x = -1470.73046875, y = 63.990886688232, z = 51.173046112061, letter = true, colis = true},
			{x = -1504.2097167969, y = 44.28625869751, z = 53.951641082764, letter = true, colis = false},
			{x = -1585.7332763672, y = 44.503841400146, z = 59.00085067749, letter = true, colis = false},
			{x = -1619.6723632813, y = 57.411979675293, z = 60.791728973389, letter = true, colis = true},
			{x = -1615.3327636719, y = 74.720077514648, z = 60.412998199463, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 211, g = 84, b = 0},
        Type  = 1
	},

	RockfordHills = {
		Pos = {
			{x = -822.11590576172, y = -28.949552536011, z = 37.660648345947, letter = true, colis = true},
			{x = -877.12579345703, y = 1.4300217628479, z = 43.068756103516, letter = true, colis = false},
			{x = -883.50225830078, y = 19.95990562439, z = 43.858791351318, letter = true, colis = false},
			{x = -904.48303222656, y = 17.959585189819, z = 45.375545501709, letter = true, colis = false},
			{x = -849.53887939453, y = 103.97817993164, z = 51.921394348145, letter = true, colis = false},
			{x = -851.21838378906, y = 178.97734069824, z = 68.720985412598, letter = true, colis = false},
			{x = -923.23107910156, y = 178.72102355957, z = 65.937400817871, letter = true, colis = false},
			{x = -954.20562744141, y = 177.81230163574, z = 64.367691040039, letter = true, colis = false},
			{x = -934.73480224609, y = 123.06588745117, z = 55.740001678467, letter = true, colis = false},
			{x = -950.38397216797, y = 125.10294342041, z = 56.440544128418, letter = true, colis = true},
			{x = -979.54205322266, y = 147.44619750977, z = 59.907157897949, letter = true, colis = false},
			{x = -1046.2899169922, y = 209.78942871094, z = 62.423046112061, letter = true, colis = false},			
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 46, g = 204, b = 113},
        Type  = 1
	},

	Vespucci = {
		Pos = {
			{x = -1091.9807128906, y = -923.61407470703, z = 2.1418874263763, letter = true, colis = false},
			{x = -1038.87109375, y = -891.09130859375, z = 4.2144069671631, letter = true, colis = true},
			{x = -948.60479736328, y = -898.53344726563, z = 1.1630630493164, letter = true, colis = true},
			{x = -919.51391601563, y = -952.21594238281, z = 1.162935256958, letter = true, colis = false},
			{x = -933.55932617188, y = -1081.3103027344, z = 1.1503119468689, letter = true, colis = false},
			{x = -954.99682617188, y = -1083.3701171875, z = 1.1503119468689, letter = true, colis = false},
			{x = -1025.9075927734, y = -1129.6602783203, z = 1.1702592372894, letter = true, colis = false},
			{x = -1061.0762939453, y = -1155.3466796875, z = 1.1118972301483, letter = true, colis = false},
			{x = -1253.8918457031, y = -1330.2947998047, z = 3.0237193107605, letter = true, colis = true},
			{x = -1106.5417480469, y = -1534.9737548828, z = 3.3808641433716, letter = true, colis = false},
			{x = -1116.1688232422, y = -1575.6658935547, z = 3.3870568275452, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 52, g = 152, b = 219},
        Type  = 1
	},

	SLS = {
		Pos = {
			{x = -50.930358886719, y = -1783.6270751953, z = 27.300802230835, letter = true, colis = false},
			{x = 13.642129898071, y = -1850.1307373047, z = 23.055648803711, letter = true, colis = false},
			{x = 110.53960418701, y = -1956.0163574219, z = 19.751287460327, letter = true, colis = false},
			{x = 151.61938476563, y = -1896.3343505859, z = 22.092262268066, letter = true, colis = false},
			{x = 158.33076477051, y = -1876.6044921875, z = 22.980903625488, letter = true, colis = true},
			{x = 221.90466308594, y = -1720.8103027344, z = 28.202871322632, letter = true, colis = false},
			{x = 249.87113952637, y = -1730.8135986328, z = 28.669330596924, letter = true, colis = false},
			{x = 263.07949829102, y = -1704.0960693359, z = 28.205499649048, letter = true, colis = false},
			{x = 332.95666503906, y = -1742.1281738281, z = 28.730531692505, letter = true, colis = false},
			{x = 326.57717895508, y = -1763.9366455078, z = 28.015428543091, letter = true, colis = false},
			{x = 321.9792175293, y = -1838.9698486328, z = 26.227586746216, letter = true, colis = false},
			{x = 440.62481689453, y = -1840.9602050781, z = 26.871042251587, letter = true, colis = false},
			{x = 385.88714599609, y = -1882.3186035156, z = 24.838005065918, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 241, g = 196, b = 15},
        Type  = 1
    }

}
