component output="false" {
	include "migrator/functions.cfm";
	include "global/functions.cfm";
	if (isDefined("application")){
		include "plugins/standalone/injection.cfm";
	}
}
