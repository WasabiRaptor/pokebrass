	dw 00525 ;national dex no
        
        db  70, 105, 105,  20,  50,  40
        evs  0,   1,   1,   0,   0,   0
        ;   hp  atk  def  spd  sat  sdf
        
        db ROCK, ROCK ; type
        db 120 ; catch rate
        db 137 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 3 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/boldore/front.dimensions"  
        db STURDY, WEAK_ARMOR     ; abilities
        db SAND_FORCE    ; hidden ability
        db GROWTH_MEDIUM_SLOW ; growth rate
        dn EGG_MINERAL ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end