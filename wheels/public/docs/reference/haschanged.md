```coldfusion
hasChanged([ property ])
```
```coldfusion
// Get a member object and change the `email` property on it
member = model("member").findByKey(params.memberId)>
member.email = params.newEmail>

// Check if the `email` property has changed
<cfif member.hasChanged("email")>
    // Do something...
</cfif>

// The above can also be done using a dynamic function like this
<cfif member.emailHasChanged()>
    // Do something...
</cfif>
```