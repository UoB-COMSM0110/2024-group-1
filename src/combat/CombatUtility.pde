class CombatUtility {

    public static int pickIndex(double[] arr) {
        double randNum = Math.random();
        double moveSum = 0;

        for (int i=0; i < arr.length; i++) {
            moveSum += moves[i];
            if (randNum < moveSum) {
                return i;
            }
        }

        return arr.length-1;
    }
}