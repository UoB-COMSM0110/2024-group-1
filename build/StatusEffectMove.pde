class StatusEffectMove extends Move {
    private List<StatusEffect> statusEffects;

    StatusEffectMove(Entity attacker, Entity target, List<StatusEffect> effects) {
        super(attacker, target, MoveType.MOVETYPE_STRATEGY);
        statusEffects = effects;
    }

    public void executeMove() {
        for (StatusEffect effect : statusEffects) {
            target.appendStatusEffect(effect);
        }
    }

    public List<StatusEffect> getEffects() {
        return statusEffects;
    }
}