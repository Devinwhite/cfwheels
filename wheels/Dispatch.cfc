component output="false" {
	include "dispatch/functions.cfm";
	include "global/functions.cfm";
	if (isDefined("application")){
        include "plugins/standalone/injection.cfm";
    }
}
