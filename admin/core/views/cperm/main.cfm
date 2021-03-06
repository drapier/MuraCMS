<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset rc.groups=application.permUtility.getGroupList(rc) />
<cfset rc.rslist=rc.groups.privateGroups />
<cfset rc.crumbdata=application.contentManager.getCrumbList(rc.contentid,rc.siteid)>
<cfset chains=$.getBean('approvalChainManager').getChainFeed(rc.siteID).getIterator()>
<cfset assignment=$.getBean('approvalChainAssignment').loadBy(siteID=rc.siteID, contentID=rc.contentID)>
<cfset colspan=6>
<cfif rc.moduleID eq '00000000000000000000000000000000000'>
	<cfset colspan=colspan+1>
</cfif>
<cfif chains.hasNext()>
	<cfset colspan=colspan+1>
</cfif>
<cfif chains.hasNext()>
	<cfset adminGroup=$.getBean('group').loadBy(groupname='Admin')>
</cfif>
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'permissions')#</h1>
<div id="nav-module-specific" class="btn-group">
	<a class="btn" href="##" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="icon-circle-arrow-left"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
</div>
<cfif rc.moduleid eq '00000000000000000000000000000000000'>#$.dspZoom(crumbdata=rc.crumbdata,class="navZoom alt")#</cfif>
<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.nodetext"),rc.rscontent.title)#</p>	
	
  <form novalidate="novalidate" method="post" name="form1" action="./?muraAction=cPerm.update&contentid=#URLEncodedFormat(rc.contentid)#&parentid=#URLEncodedFormat(rc.parentid)#">
           <h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h2>
			<table class="mura-table-grid">
			<tr>
			<cfif chains.hasNext()><th>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchainexempt')#</th></cfif> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th>
			<cfif rc.moduleID eq '00000000000000000000000000000000000'><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
            <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
          <cfif chains.hasNext()>
          		 <tr>
	              <td><input name="exemptID" type="checkbox" class="checkbox" value="#adminGroup.getUserID()#" <cfif len(assignment.getExemptID()) and listFind(assignment.getExemptID(),adminGroup.getUserID())>checked</cfif>></td>
	              <td><input type="radio" disabled checked></td>
				   <td><input type="radio" disabled></td>
				   <td><input type="radio" disabled></td>
				   <td><input type="radio" disabled></td>
				   <td><input type="radio" disabled></td>
					<td nowrap class="var-width">Admin</td>
	            </tr>
          </cfif>
		  <cfif rc.rslist.recordcount>
          <cfloop query="rc.rslist"> 
		   <cfset perm=application.permUtility.getGroupPerm(rc.rslist.userid,rc.contentid,rc.siteid)/>
            <tr>
              <cfif chains.hasNext()><td><input name="exemptID" type="checkbox" class="checkbox" value="#rc.rslist.userid#" <cfif perm eq 'editior' and len(assignment.getExemptID()) and listFind(assignment.getExemptID(),rc.rslist.userid)>checked</cfif><cfif perm neq 'editior'>disabled</cfif>></td></cfif> 
              <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
	      <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
		   <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif>></td>
		    <cfif rc.moduleID eq '00000000000000000000000000000000000'><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
		    <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
		   
		<td nowrap class="var-width">#rc.rslist.GroupName#</td>
            </tr></cfloop>
		<cfelse>
		 <tr> 
              <td class="noResults" colspan="#colspan#">
			#application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
		</cfif>
		</table>
		
		<cfset rc.rslist=rc.groups.publicGroups />
		<h2>#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</h2>
		<p>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermscript')##application.rbFactory.getKeyValue(session.rb,'permissions.memberpermnodescript')#</p>
		<table class="mura-table-grid">
			<tr> 
			<cfif chains.hasNext()><th>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchainexempt')#</th></cfif>
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th>
			<cfif rc.moduleID eq '00000000000000000000000000000000000'><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
            <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif rc.rslist.recordcount>
          <cfloop query="rc.rslist"> 
		   <cfset perm=application.permUtility.getGroupPerm(rc.rslist.userid,rc.contentid,rc.siteid)/>
            <tr> 
             <cfif chains.hasNext()><td><input name="exemptID" type="checkbox" class="checkbox" value="#rc.rslist.userid#" <cfif perm eq 'editior' and len(assignment.getExemptID()) and listFind(assignment.getExemptID(),rc.rslist.userid)>checked</cfif><cfif perm neq 'editior'>disabled</cfif>></td></cfif> 
              <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
	      <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
		   <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif>></td>
		    <cfif rc.moduleID eq '00000000000000000000000000000000000'><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
		    <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
		<td nowrap class="var-width">#HTMLEditFormat(rc.rslist.GroupName)#</td>
            </tr></cfloop>
		<cfelse>
		 <tr> 
              <td class="noResults" colspan="#colspan#">
			#application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
		</cfif>
		</table>

	
	<cfif chains.hasNext()>
	<h2>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchain')#</h2>
	<div class="control-group">
        <label class="control-label">
           <a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.approvalchain"))#">#application.rbFactory.getKeyValue(session.rb,'permissions.selectapprovalchain')# <i class="icon-question-sign"></i></a>
        </label>
        <div class="controls">
            <select name="chainID" class="dropdown">
            	<option value="">#application.rbFactory.getKeyValue(session.rb,'permissions.none')#</option>
            	<cfloop condition="chains.hasNext()">
            		<cfset chain=chains.next()>
            		<option value="#chain.getChainID()#"<cfif assignment.getChainID() eq chain.getChainID()> selected</cfif>>#HTMLEditFormat(chain.getName())#</option>
            	</cfloop>
         	</select>
        </div>
    </div>
    </cfif>
	<div class="form-actions no-offset">
		 <input type="button" class="btn" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'permissions.update')#" />
	</div>
           <input type="hidden" name="router" value="#HTMLEditFormat(cgi.HTTP_REFERER)#">
           <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
           <input type="hidden" name="startrow" value="#HTMLEditFormat(rc.startrow)#">
		  <input type="hidden" name="topid" value="#HTMLEditFormat(rc.topid)#">
		  <input type="hidden" name="moduleid" value="#HTMLEditFormat(rc.moduleid)#">
		   #rc.$.renderCSRFTokens(context=rc.contentid,format="form")#
		</form></td>
  </tr>
</table>

<script>
	$(function(){
			$("input[type='radio']").click(function(){
				var e=$(this).closest('tr').find("input[name='exemptID']")
				
				if($("input[name='" + $(this).attr('name') + "']:checked").val() != 'editor'){
					e.attr('checked',false)
					e.attr('disabled',true)
				} else {
					e.attr('disabled',false)
				}
			})
		}
	)
</script>
</cfoutput>