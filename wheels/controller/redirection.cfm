<cfscript>
	/**
	*  PUBLIC CONTROLLER REQUEST FUNCTIONS
	*/
	public void function redirectTo( 
		boolean back=false,
		boolean addToken,
		numeric statusCode,
		string route="",
		string controller="",
		string action="",
		any key="",
		string params="",
		string anchor="",
		boolean onlyPath,
		string host,
		string protocol,
		numeric port,
		string url="",
	) {
		var loc = {};
		$args(name="redirectTo", args=arguments);

		// set flash if passed in
		loc.functionInfo = GetMetaData(variables.redirectTo);
		if (StructCount(arguments) > ArrayLen(loc.functionInfo.parameters))
		{
			// since more than the arguments listed in the function declaration was passed in it's possible that one of them is intended for the flash

			// create a list of all the argument names that should not be set to the flash
			// this includes arguments to the function itself or ones meant for a route
			loc.nonFlashArgumentNames = "";
			if (Len(arguments.route))
			{
				loc.nonFlashArgumentNames = ListAppend(loc.nonFlashArgumentNames, $findRoute(argumentCollection=arguments).variables);
			}
			loc.iEnd = ArrayLen(loc.functionInfo.parameters);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.nonFlashArgumentNames = ListAppend(loc.nonFlashArgumentNames, loc.functionInfo.parameters[loc.i].name);
			}

			// loop through arguments and when the first flash argument is found we set it
			loc.argumentNames = StructKeyList(arguments);
			loc.iEnd = ListLen(loc.argumentNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(loc.argumentNames, loc.i);
				if (!ListFindNoCase(loc.nonFlashArgumentNames, loc.item))
				{
					loc.key = REReplaceNoCase(loc.item, "^flash(.)", "\l\1");
					loc.flashArguments = {};
					loc.flashArguments[loc.key] = arguments[loc.item];
					flashInsert(argumentCollection=loc.flashArguments);
				}
			}
		}

		// set the url that will be used in the cflocation tag
		if (arguments.back)
		{
			if (Len(request.cgi.http_referer) && FindNoCase(request.cgi.server_name, request.cgi.http_referer))
			{
				// referrer exists and points to the same domain so it's ok to redirect to it
				loc.url = request.cgi.http_referer;
				if (Len(arguments.params))
				{
					// append params to the referrer url
					loc.params = $constructParams(arguments.params);
					if (Find("?", request.cgi.http_referer))
					{
						loc.params = Replace(loc.params, "?", "&");
					}
					else if (left(loc.params, 1) == "&" && !Find(request.cgi.http_referer, "?"))
					{
						loc.params = Replace(loc.params, "&", "?", "one");
					}
					loc.url &= loc.params;
				}
			}
			else
			{
				// we can't redirect to the referrer so we either use a fallback route/controller/action combo or send to the root of the site
				if (Len(arguments.route) || Len(arguments.controller) || Len(arguments.action))
				{
					loc.url = URLFor(argumentCollection=arguments);
				}
				else
				{
					loc.url = get("webPath");
				}
			}
		}
		else if (Len(arguments.url))
 		{
 			loc.url = arguments.url;
 		}
		else
		{
			loc.url = URLFor(argumentCollection=arguments);
		}

		// schedule or perform the redirect right away
		if (arguments.delay)
		{
			if (StructKeyExists(variables.$instance, "redirect"))
			{
				// throw an error if the developer has already scheduled a redirect previously in this request
				$throw(type="Wheels.RedirectToAlreadyCalled", message="`redirectTo()` was already called.");
			}
			else
			{
				// schedule a redirect that will happen after the action code has been completed
				variables.$instance.redirect = {};
				variables.$instance.redirect.url = loc.url;
				variables.$instance.redirect.addToken = arguments.addToken;
				variables.$instance.redirect.statusCode = arguments.statusCode;
				variables.$instance.redirect.$args = arguments;
			}
		}
		else
		{
			// do the redirect now using cflocation
			$location(url=loc.url, addToken=arguments.addToken, statusCode=arguments.statusCode);
		}
	}
</cfscript>