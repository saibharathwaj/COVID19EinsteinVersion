global class StateApex implements Schedulable, Database.AllowsCallouts {
    global void execute(SchedulableContext sc){
        CovidDistrict.upsertDistrict();
    }
}
