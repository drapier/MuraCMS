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
<cfsilent>
	<cfset $.addToHTMLHeadQueue("listImageStyles.cfm")>
	
	<cfif not structKeyExists(arguments,"type")>
		<cfset arguments.type="Feed">
	</cfif>
	
	<cfif not structKeyExists(arguments,"fields")>
		<cfset arguments.fields="Date,Title,Image,Summary,Credits,Tags">
	</cfif>
	
	<cfset arguments.hasImages=listFindNoCase(arguments.fields,"Image")>
	
	<cfif arguments.hasImages>
		<cfset arguments.imageURLArgs=structNew()>
		<cfset arguments.imageURLArgs.size="small">
		
		<cfif not structKeyExists(arguments,"imagePadding")>
			<cfset arguments.imagePadding=10>
		</cfif>
		
		<cfif structKeyExists(arguments,"imageSize")>
			<cfset arguments.imageURLArgs.size=arguments.imageSize>
		</cfif>
		
		<cfif arguments.imageSize eq "Custom"
			and not (
				structKeyExists(arguments,"imageWidth") 
				or structKeyExists(arguments,"imageHeight")
				)
			and not (
				structKeyExists(arguments,"imageWidth") 
				and  structKeyExists(arguments,"imageHeight")
				and arguments.imageWidth eq "auto"
				and arguments.imageHeight eq "auto"
			)>
			<cfset arguments.imageSize="small">
		</cfif>
		
		<cfif arguments.imageSize neq "custom">
			<cfif $.siteConfig('gallery#arguments.imageSize#ScaleBy') eq 'x'>
				<cfset arguments.imageStyles.paddingLeft=$.siteConfig('gallery#arguments.imageSize#Scale') + arguments.imagePadding>
				<cfset arguments.imageStyles.minHeight="auto">
			<!--- Conditional styles for images constrained by height --->
			<cfelseif $.siteConfig('gallery#arguments.imageSize#ScaleBy') eq 'y'>
				<cfset arguments.imageStyles.paddingLeft="auto">
				<cfset arguments.imageStyles.minHeight=$.siteConfig('gallery#arguments.imageSize#Scale') + arguments.imagePadding>
			<cfelse>
			<!--- Styles for images cropped to square --->
				<cfset arguments.imageStyles.paddingLeft=$.siteConfig('gallery#arguments.imageSize#Scale') + arguments.imagePadding>
				<cfset arguments.imageStyles.minHeight=$.siteConfig('gallery#arguments.imageSize#Scale') + arguments.imagePadding>
			</cfif>
		<cfelse>
			<cfif structKeyExists(arguments,"imageWidth")>
				<cfset arguments.imageURLArgs.width=arguments.imageWidth>
				<cfset arguments.imageStyles.paddingLeft=arguments.imageWidth + arguments.imagePadding>
			<cfelse>
				<cfset arguments.imageURLArgs.width="auto">
				<cfset arguments.imageStyles.paddingLeft="auto">
			</cfif>
			<cfif structKeyExists(arguments,"imageHeight")>
				<cfset arguments.imageURLArgs.height=arguments.imageHeight>
				<cfset arguments.imageStyles.minHeight=arguments.imageHeight + arguments.imagePadding>
			<cfelse>
				<cfset arguments.imageURLArgs.height="auto">
				<cfset arguments.imageStyles.minHeight="auto">
			</cfif>
		</cfif>
		
		<cfif arguments.imageStyles.minHeight neq "auto">
			<cfset arguments.imageStyles.minHeight="#arguments.imageStyles.minHeight#px">
		</cfif>
		<cfif arguments.imageStyles.paddingLeft neq "auto">
			<cfset arguments.imageStyles.paddingLeft="#arguments.imageStyles.paddingLeft#px">
		</cfif>
		
		<cfset arguments.imageStyles.markup='style="min-height:#arguments.imageStyles.minHeight#;padding-left:#arguments.imageStyles.paddingLeft#;"'>
	</cfif>
</cfsilent>
<cfif getListFormat() eq "ul">
	<ul>
</cfif>
<cfloop condition="arguments.iterator.hasNext()">
	<cfsilent>
		<cfset arguments.item=arguments.iterator.next()>
		<cfset arguments.class=""/>
		
		<cfif not arguments.iterator.hasPrevious()> 
			<cfset arguments.class=listAppend(arguments.class,"first"," ")/> 
		</cfif>
		
		<cfif not arguments.iterator.hasNext()> 
			<cfset arguments.class=listAppend(arguments.class,"last"," ")/> 
		</cfif>
			
		<cfset arguments.hasImage=arguments.hasImages and len(arguments.item.getValue('fileID')) and showImageInList(arguments.item.getValue('fileEXT')) />
			
		<cfif arguments.hasImage>
			<cfset arguments.class=listAppend(arguments.class,"hasImage"," ")>
		</cfif>
	</cfsilent>
	<cfoutput>
	<!---  UL MARKUP -------------------------------------------------------------------------- --->
	<cfif $.getListFormat() eq "ul">
		<li>
			<cfloop list="#arguments.fields#" index="arguments.field">
				<cfswitch expression="#arguments.field#">
					<cfcase value="Image">
						<cfif arguments.hasImage>
							<cfif cookie.mobileFormat>
							<img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/>	
							<cfelse>
							<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>	
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="Date">
						<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
						<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>
						<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
						<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></p>
						<cfelseif arguments.type eq "Calendar">
						<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></p>
						<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
						<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</p>		
						</cfif>
					</cfcase>
					<cfcase value="Title">
						<h3><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#addlink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'))#</h3>
					</cfcase>
					<cfcase value="Summary">
						<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
							#$.setDynamicContent(arguments.item.getValue('summary'))#
						</cfif>
					</cfcase>
					<cfcase value="Credits">
						<cfif len(arguments.item.getValue('credits'))>
							<p class="credits">#$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</p>
						</cfif>
					</cfcase>
					<cfcase value="Comments">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
							<cfif not cookie.mobileFormat>
							 	<p class="comments">#$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#$.rbKey("list.comments")#(#$.getBean('contentGateway').getCommentCount($.event('siteID'),arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),$.event('siteID'),'##comments')#</p>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="Tags">
						<cfif len(arguments.item.getValue('tags'))>
							<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
							<p class="tags">
								#$.rbKey('tagcloud.tags')#: 
								<cfif cookie.mobileFormat>
								<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
									<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
									#arguments.tag#<cfif arguments.tagLen gt arguments.t>, </cfif>
								</cfloop>
								<cfelse>
								<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
									<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
									<a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#arguments.tag#</a><cfif arguments.tagLen gt arguments.t>, </cfif>
								</cfloop>
								</cfif>
							</p>
						</cfif>
					</cfcase>
					<cfcase value="Rating">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
							<p class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></p>	 	
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(arguments.item.getValue(arguments.field))>
						 	<p class="#lcase(arguments.field)#">#HTMLEditFormat(arguments.item.getValue(arguments.field))#</p>	 	
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</li>
	<cfelse>
	<!---  DL MARKUP -------------------------------------------------------------------------- --->
		<dl class="clearfix<cfif arguments.class neq ''> #arguments.class#</cfif>"<cfif arguments.hasImage> #arguments.imageStyles.markup#</cfif>>
			<cfloop list="#arguments.fields#" index="arguments.field">
				<cfswitch expression="#arguments.field#">
					<cfcase value="Date">
						<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
						<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>
						<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
						<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></dt>
						<cfelseif arguments.type eq "Calendar">
						<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></dt>
						<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
						<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>		
						</cfif>
					</cfcase>
					<cfcase value="Title">
						<dt class="title"><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',$.globalConfig('context'),$.globalConfig('stub'),$.globalConfig('indexFile'))#</dt>
					</cfcase>
					<cfcase value="Image">
						<cfif arguments.hasImage>
						<dd class="image">
							<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>
						</dd>
						</cfif>
					</cfcase>
					<cfcase value="Summary">
						<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
						 	<dd class="summary">#$.setDynamicContent(arguments.item.getValue('summary'))# <span class="readMore">#$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),$.rbKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',$.globalConfig('context'),$.globalConfig('stub'),$.globalConfig('indexFile'))#</span></dd>
						</cfif>
					</cfcase>
					<cfcase value="Credits">
						<cfif len(arguments.item.getValue('credits'))>
						 	<dd class="credits">#$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</dd>
						</cfif>
					</cfcase>
					<cfcase value="Comments">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
						 	<dd class="comments">#$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#$.rbKey("list.comments")#(#$.getBean('contentGateway').getCommentCount($.event('siteID'),arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),$.event('siteID'),'##comments')#</dd>
						</cfif>
					</cfcase>
					<cfcase value="Tags">
						<cfif len(arguments.item.getValue('tags'))>
							<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
							<dd class="tags">
								#$.rbKey('tagcloud.tags')#: 
								<cfloop from="1" to="#arguments.tagLen#" index="t">
								<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
								<a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#arguments.tag#</a><cfif arguments.tagLen gt t>, </cfif>
								</cfloop>
							</dd>
						</cfif>
					</cfcase>
					<cfcase value="Rating">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
						 	<dd class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></dd>	 	
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(arguments.item.getValue(arguments.field))>
						 	<dd class="#lcase(arguments.field)#">#HTMLEditFormat(arguments.item.getValue(arguments.field))#</dd>	 	
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</dl>
	</cfif>	
	</cfoutput>
</cfloop>

<cfif getListFormat() eq "ul">
	</ul>
</cfif>
