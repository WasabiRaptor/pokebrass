	dw 00182 ;national dex no
        
        db  75,  80,  95,  50,  90, 100
        evs  0,   0,   0,   0,   0,   3
        ;   hp  atk  def  spd  sat  sdf
        
        db GRASS, GRASS ; type
        db 45 ; catch rate
        db 221 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 4 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/bellossom/front.dimensions"  
        db CHLOROPHYLL, CHLOROPHYLL     ; abilities
        db HEALER    ; hidden ability
        db GROWTH_MEDIUM_SLOW ; growth rate
        dn EGG_GRASS ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end