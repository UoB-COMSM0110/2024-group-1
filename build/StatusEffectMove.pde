class StatusEffectMove extends Move {
    private List<StatusEffect> statusEffects;

    StatusEffectMove(Entity attacker, Entity target, List<StatusEffect> effects) {
        super(attacker, target, MoveType.MOVETYPE_POISON);
        statusEffects = effects;
    }

    public void executeMove() {
        for (StatusEffect effect : statusEffects) {
            target.appendStatusEffect(effect);
        }
    }
}