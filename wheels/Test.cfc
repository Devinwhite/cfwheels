component output="false" displayName="Test" {
	include "test/functions.cfm";
	include "global/functions.cfm";
	if (isDefined("application")){
		include "plugins/standalone/injection.cfm";
	}
}
