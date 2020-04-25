({
	init : function(component, event, helper) {
		component.set('v.mycolumns',[
            {label:'Country',fieldName:'Country',sortable:true,type:'text'},
            {label:'New Confirmed',fieldName:'NewConfirmed',sortable:true,type:'text'},
            {label:'Total Confirmed',fieldName:'TotalConfirmed',sortable:true,type:'text'},
            {label:'New Deaths',fieldName:'NewDeaths',sortable:true,type:'text'},
            {label:'Total Deaths',fieldName:'TotalDeaths',sortable:true,type:'text'},
            {label:'New Recovered',fieldName:'NewRecovered',sortable:true,type:'text'},
            {label:'Total Recovered',fieldName:'TotalRecovered',sortable:true,type:'text'}
        ]);
        var action=component.get("c.getCOVID19Summary");
        action.setParams({
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.COVID19CountrySummaryList",response.getReturnValue());
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
	}
})