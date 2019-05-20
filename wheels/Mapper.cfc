component output="false" {
	variables.$wheelsInclude = "cfml,internal,util";
	include "mapper/functions.cfm";
	include "global/functions.cfm";
	if (isDefined("application")){
		include "plugins/standalone/injection.cfm";
	}
}
