fx_version 'cerulean'
games {'gta5'}
description 'MarkoMods.com SA80'

files{
	'**/markomods-sa80-components.meta',
	'**/markomods-sa80-archetypes.meta',
	'**/markomods-sa80-animations.meta',
	'**/markomods-sa80-pedpersonality.meta',
	'**/markomods-sa80.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/markomods-sa80-components.meta'
data_file 'WEAPON_METADATA_FILE' '**/markomods-sa80-archetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/markomods-sa80-animations.meta'
data_file 'PED_PERSONALITY_FILE' '**/markomods-sa80-pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/markomods-sa80.meta'

client_script 'cl_weaponNames.lua'

escrow_ignore {
	'stream/**/*.ytd',
	'data/**/*.meta',
	'cl_weaponNames.lua'
}
  
lua54 'yes'
dependency '/assetpacks'