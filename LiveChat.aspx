<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="LiveChat.aspx.cs" Inherits="OlineClinic.LiveChat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <title></title>
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" href="css/jquery.mCustomScrollbar.css">
    <style type="text/css">
        .btn
        {
            background: url("../images/book_btn_revise.png") no-repeat scroll left top rgba(0, 0, 0, 0);
            float: right;
            font-family: Helvetica;
            font-size: 15px;
            font-weight: bold;
            height: 30px;
            padding-top: 6px;
            text-align: center;
            text-decoration: none;
            text-transform: none;
            vertical-align: middle;
            width: 104px;
            color: #000;
        }
        .btn_show
        {
            background: url("images/update_btn.png") no-repeat scroll left top rgba(0, 0, 0, 0);
            color: #000;
            float: right;
            font-size: 14px;
            height: 34px;
            padding-top: 10px;
            text-align: center;
            text-decoration: none;
            text-transform: none;
            vertical-align: middle;
            width: 125px;
            cursor: pointer;
        }
        .btn:hover
        {
            color: Black;
        }
        .connectinv_div
        {
            background: url(images/connecting.gif) no-repeat;
            color: #FFFFFF;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
            height: 30px;
            width: 600px;
            margin: auto;
            background-color: Black;
        }
        
        .alert
        {
            padding: 8px 35px 8px 14px;
            margin-bottom: 18px;
            color: #c09853;
            text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
            background-color: #fcf8e3;
            border: 1px solid #fbeed5;
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            width: auto !important;
        }
        
        .alert-heading
        {
            color: inherit;
        }
        
        .alert .close
        {
            position: relative;
            top: -2px;
            right: -21px;
            line-height: 18px;
        }
        .alert-success
        {
            color: #468847;
            background-color: #dff0d8;
            border-color: #d6e9c6;
        }
        #main button, #disp
        {
            width: 8em;
            vertical-align: middle;
        }
        #main button
        {
            padding: 0.4em;
            font-size: 1.1em;
        }
        #disp
        {
            background-color: white;
            font-size: 2em;
            width: 7.25em;
            font-family: "Courier New";
        }
        
        #main
        {
            /* float: left;
            margin-left: 15px;
            margin-top: 25px;   */
            text-align: center;
            white-space: nowrap;
            font-weight: bold;
        }
        
        #remote
        {
            position: absolute;
            top: 1px;
            right: 1px;
            visibility: hidden;
        }
        
        #lap
        {
            margin-top: 0.5em;
        }
        #content-wrapper
        {
            border-radius: 10px 10px 0 0;
        }
        .myscroll
        {
            bottom: -10px;
            height: 50px;
            position: absolute;
            width: 100%;
            z-index: 10;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    <asp:HiddenField ID="hdn" runat="server" />
    <asp:HiddenField ID="hdn1" runat="server" />
    <div>
        <input type="text" id="publisher_box" name="publisher_box" style="display: none" />
        <input type="text" id="subscriber_box" name="subscriber_box" style="display: none" />
    </div>
    <div class="white-back-internal" style="height: auto; min-height: 500px;">
        <div class="box-width_bx2">
            <div class="left_home_btn1">
                <asp:HyperLink CssClass="btn_show" runat="server" Text="Home" ID="link"></asp:HyperLink>
                <a href="javascript:;" class="btn_show" runat="server" id="lbPatient" visible="false"
                    target="_blank">Patient History</a>
            </div>
            <div class="dark-back" id="trName">
                <div class="product-text">
                    <div class="timer_input">
                        <input type="text" id="disp" style="display: block;" />
                    </div>
                    <div id="main" class="three_icon_bx">
                        <asp:LinkButton CssClass="img_btn tooltip" runat="server" ID="lnkDisconnect" title="End Consult"  OnClientClick="return ss();" Visible=false > <img src="images/endConsultIcon.png" alt="" title="End Consult" style="visibility:hidden;"/></asp:LinkButton>
                        <a runat="server" id="lnkDisconnect1" class="img_btn tooltip" title="Disconnect"   onserverclick="lnkDisconnect1_ServerClick">
                            <img src="images/disconnect_icon.png" alt="" /></a>
                        <a runat="server" id="lnkShowTimer" class="img_btn tooltip"   title="Show Timer"  onclick="showhideTimer();">
                            <img id="imgShowTimer" src="images/showTimer_icon.png" alt="" /></a>
                        <a runat="server" id="lnkShowVideo" class="img_btn tooltip" title="Show Video" >
                            <img id="imgShowVideo" src="images/showVideo_icon.png" alt="" />
                        </a>
                        <div class="videobox_mobileno">
                            <asp:Label ID="lblPatientMobileNo" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="chat-div" id="outer">
                <div class="connectinv_div" id="connect">
                </div>
            </div>
            <div id="divthanks" style="margin: 20px; display: none; font-size: 26px; margin-top: 219px !important;"
                class="div-thanks">
                <div class="alert alert-success" align="center">
                    Your consult has now finished. Thank you for using MyOnlineClinic!</div>
            </div>
            <div class="main_cont_chat">
                <div id="counter_2" style="margin: auto !important; width: 300px !important; display: none;">
                </div>
                <div class="desc" style="margin: auto !important; width: 300px !important;">
                </div>
                <div id="MainDiv" class="video_bx_img2_bx">
                    <div class="myPublisherDiv_bx">
                        <div class="left_name_bx">
                            <asp:Label ID="lbltrainer" runat="server" Text="Trainer Name" CssClass="MyCapitalize"></asp:Label>
                        </div>
                        <div id="video" class="videoChat_bx">
                            <div id="myPublisherDiv">
                            </div>
                        </div>
                    </div>
                    <div class="subscribersDiv_bx">
                        <div id="subsDiv">
                            <div class="left_name_bx right_name_bx">
                                <asp:Label ID="lbltrainee" runat="server" Text="Trainee Name" CssClass="MyCapitalize"></asp:Label>
                            </div>
                            <div id="subscribersDiv" class="videoChat_bx">
                            </div>
                        </div>
                    </div>
                    <div style="clear: both">
                    </div>
                </div>
                <asp:Label ID="lblmsg" runat="server" Text="Label" ForeColor="Red" Visible="false"></asp:Label>
                <br />
                <asp:HiddenField ID="hdsession" runat="server" />
                <asp:HiddenField ID="hdtoken" runat="server" />
                <asp:HiddenField ID="AppontMentId" runat="server" />
                <asp:HiddenField ID="hdnDuration" runat="server" />
                <asp:HiddenField ID="HiddenField1" runat="server" />
                <asp:HiddenField ID="hdnUserType" runat="server" />
            </div>
        </div>
    </div>
    <table border="1" style="display: none;">
        <tr>
            <th>
                Lap #
            </th>
            <th>
                This Lap
            </th>
            <th>
                Running Total
            </th>
        </tr>
        <tbody id="lap">
        </tbody>
    </table>
    <div class="chat_box">
        <div class="chat_header">
            <div class="chat_close">
            </div>
            <div class="chat_minimize">
                <span></span>
            </div>
            <div class="clr">
            </div>
        </div>
        <div id="dvScrollArea" class="chat_scroll_type">
            <div class="chat_scroll" id="chat_scroll">
                <div id="dvChatArea" class="dvChatArea">
                    <div class="myscroll">
                    </div>
                </div>
            </div>
            <div class="chat_typing_wrap">
                <textarea id="txtChat" cols="" rows="" class="textarea" onkeyup="if (event.keyCode == 13 && !event.shiftKey) { sendText();}"></textarea>
                <input type="button" id="btnSend" value="send" class="sendBtn" style="width: 60px;"
                    onclick="sendText();" />
                <div class="clr">
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnDoctorName" runat="server" />
    <asp:HiddenField ID="hdnPatientName" runat="server" />

    <asp:HiddenField ID="HiddenField2" runat="server" />

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js">
    </script>
    
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js" type="text/javascript"></script>
      <link rel="stylesheet" type="text/css" href="css/tooltipster.css" />
        <script type="text/javascript" src="js/jquery.tooltipster.js"></script>
        <script type="text/javascript">
		$(document).ready(function() {
			 $('.tooltip').tooltipster({				
				 fixedWidth: 300				 
				 });			 
		});
	</script>
    <script src="js/opentok.min.js" type="text/javascript"></script>
    <script src="js/jquery.mCustomScrollbar.concat.min.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        var publisher;
        var sessionId;
        var session;
        var subscriber;

        $(document).ready(function ()
        {
            $('.menu_nav').css("display", "none");
            $('#content-wrapper').css("border", "1px solid #b3b3b3", "border-radius", "10px 10px 0 0");
            $('.homepage').css("width", "auto");
            $('.myPublisherDiv').css("width", "100%");
            $(".myPublisherDiv_bx").draggable();
            $(".subscribersDiv_bx").draggable();
        });

        (function ($)
        {
            $(window).load(function ()
            {
                $("#chat_scroll").mCustomScrollbar(); /*demo fn*/

            });
        })(jQuery);

        function disconnectChat()
        {
            console.log("disconnectChat");
            var IndexValue = document.getElementById('<%=AppontMentId.ClientID %>').value;
            var durationInMin = document.getElementById('<%=hdnDuration.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "LiveChat.aspx/VideoSessionClose",
                data: '{"Id":"' + IndexValue + '","duration":"' + durationInMin + '"}',
                contentType: "application/json; charset=utf-8",
                success: function (msg)
                {
                    $('#MainDiv').css("display", 'none');
                    $('#counter_2').css("display", 'none');
                    $('#divthanks').css("display", 'block');
                    $('#trName').css("display", 'none');
                    session.disconnect();
                },
                error: function ()
                {
                    alert('Error occured !!');
                    return false;
                }
            });
        }

        function disconnectChatForPatient()
        {
            var HiddenField1 = document.getElementById('<%= HiddenField1.ClientID %>').value;
            var hdnDuration = document.getElementById('<%= hdnDuration.ClientID %>').value;

            if (HiddenField1.value != '' && hdnDuration.value != '') {
                checkChatStaus();
            }
            setTimeout(function () { disconnectChatForPatient() }, 1000);
        }

        var testing = '';
        function StartVideo()
        {
            console.log("StartVideo");
            var HiddenField1 = document.getElementById('<%= HiddenField1.ClientID %>').value;
            sessionId = document.getElementById('<%=hdsession.ClientID%>').value;
            console.log(sessionId);
            var apiKey = '<%= myonline.Framework.Util.ClsCommon.OpenTokApiKey %>';   //"28162832";    //"33178912";
            var token = document.getElementById('<%=hdtoken.ClientID%>').value;
            session = OT.initSession(apiKey, sessionId);

            session.on({
                streamCreated: function (event) {
                    session.subscribe(event.stream, 'subscribersDiv', { insertMode: 'append' });
                    session.subscribe(event.stream, 'subscribersDiv', { height: 400, style: { buttonDisplayMode: "off"} });
                    loadTimer();
                },
                connectionDestroyed: function (event) {
                    var HiddenField1 = document.getElementById('<%= HiddenField1.ClientID %>');
                    if (HiddenField1.value != '')
                    {
                        alert('Doctor has Disconnected the session.');
                    }
                    else 
                    {
                        alert('Patient has Disconnected the session.');
                    }
                    var hdnUserType = document.getElementById('<%= hdnUserType.ClientID %>');
                    
                    if (hdnUserType.value == 1) {
                        window.location.href = "patientfutureappointments.aspx";
                    }
                    else {
                        window.location.href = "doctorfutureconsults.aspx";
                    }
                    console.log("connectionDestroyed.");
                },
                sessionDisconnected: function sessionDisconnectHandler(event) {
                    // The event is defined by the SessionDisconnectEvent class 
                    console.log("Disconnected from the session.");
                    if (event.reason == "networkDisconnected") {
                        console.log("Your network connection terminated.")
                    }
                }
            });

            session.connect(token, function (error)
            {
                if (error) {
                    console.log(error.message);
                } else {
                    publisher = session.publish('myPublisherDiv', { publishAudio: true, publishVideo: true, height: 400, style: { buttonDisplayMode: "off"} });
                }
            });

            session.on("signal", function (event)
            {
                if (event.data != '') {
                    var dvChatText = document.getElementById('dvChatArea');
                    var chatText = '<div  class="chat">' + event.data.toString() + '</div>';
                    dvChatText.innerHTML = dvChatText.innerHTML + chatText;
                    $("#chat_scroll").mCustomScrollbar("scrollTo", "last");
                    document.getElementById('dvScrollArea').style.display = 'block';
                }
            });

            if (HiddenField1 != '') {
                disconnectChatForPatient();
            }
        }

        function sendText()
        {
            var Text = document.getElementById('txtChat').value;

            var userType = '<%= intUserType %>';
            
            var patientName = document.getElementById('<%= hdnPatientName.ClientID %>').value;
            var doctorName = document.getElementById('<%= hdnDoctorName.ClientID %>').value;

            if (Math.abs(userType) == <%= (int)myonline.Framework.Util.ClsCommon.UserType.Patient %>) 
            {
                    //  Text =  '<span style="text-transform:capitalize;font-weight:bold;">' + patientName + '</span>' + ': ' + Text;
                    Text =  patientName.toUpperCase() + ': ' + Text;
            }
            if (Math.abs(userType) == <%= (int)myonline.Framework.Util.ClsCommon.UserType.Doctor %>) 
            {
                    //  Text =  '<span style="text-transform:capitalize;font-weight:bold;">' + doctorName + '</span>' + ': ' + Text;
                    Text =  doctorName.toUpperCase() + ': ' + Text;
            }

            session.signal(
		    {
		        connections: sessionId,
		        data: Text,
		        type: "textMessage"
		    },
		      function (error)
		      {
		          if (error) {
		              console.log("signal error ("
						       + error.code
						       + "): " + error.reason);
		          } else {
		              console.log("signal sent.");
		              document.getElementById('txtChat').value = '';
		          }
		      }
		    );
        }

        // 0/1 = start/end
        // 2 = state
        // 3 = length, ms
        // 4 = timer
        // 5 = epoch
        // 6 = disp el
        // 7 = lap count

        var t = [0, 0, 0, 0, 0, 0, 0, 1];

        function ss()
        {
            t[t[2]] = (new Date()).valueOf();
            t[2] = 1 - t[2];

            if (0 == t[2]) {
                clearInterval(t[4]);
                t[3] += t[1] - t[0];
                var row = document.createElement('tr');
                var td = document.createElement('td');
                td.innerHTML = (t[7]++);
                row.appendChild(td);
                td = document.createElement('td');
                td.innerHTML = format(t[1] - t[0]);
                row.appendChild(td);
                td = document.createElement('td');
                td.innerHTML = format(t[3]);
                document.getElementById('<%= hdnDuration.ClientID %>').value = format(t[1] - t[0]);
                console.log("ss");
                disconnectChat();
                row.appendChild(td);
                document.getElementById('lap').appendChild(row);
                t[4] = t[1] = t[0] = 0;
                disp();
            } else {
                t[4] = setInterval(disp, 43);
            }
            return false;
        }

        function r()
        {
            if (t[2]) ss();
            t[4] = t[3] = t[2] = t[1] = t[0] = 0;
            disp();
            document.getElementById('lap').innerHTML = '';
            t[7] = 1;
        }

        function disp()
        {
            if (t[2]) t[1] = (new Date()).valueOf();
            t[6].value = format(t[3] + t[1] - t[0]);
        }
        function format(ms)
        {
            // used to do a substr, but whoops, different browsers, different formats
            // so now, this ugly regex finds the time-of-day bit alone
            var d = new Date(ms + t[5]).toString().replace(/.*([0-9][0-9]:[0-9][0-9]:[0-9][0-9]).*/, '$1');
            var x = String(ms % 1000);
            while (x.length < 3) x = '0' + x;
            // d += '.' + x;
            return d;
        }

        function loadTimer()
        {
            $('#outer').css("display", 'none');
            $('#counter_2').css("display", 'block');

            t[5] = new Date(1970, 1, 1, 0, 0, 0, 0).valueOf();
            t[6] = document.getElementById('disp');
            disp();
            ss();
        }

        function checkChatStaus()
        {
            var HiddenField1 = document.getElementById('<%= HiddenField1.ClientID %>');
            var appId = document.getElementById('<%=AppontMentId.ClientID %>').value;
            var strUrl = 'Handlers/Handler.ashx?id=' + appId;
            if (appId != null && appId != '' && appId != '0') {
                $.get(strUrl, function (data)
                {
                    if (data != null && data.toString().indexOf('success', 0) >= 0) {
                        $('#MainDiv').css("display", 'none');
                        $('#counter_2').css("display", 'none');
                        $('#divthanks').css("display", 'block');
                        $('#trName').css("display", 'none');
                        HiddenField1.value = '';
                    }
                });
            }
        }

        jQuery(document).ready(function ()
        {
            jQuery('.chat_header .chat_minimize').click(function ()
            {
                jQuery('.chat_scroll_type').slideToggle("fast");
            });
            jQuery('.chat_header .chat_close').click(function ()
            {
                jQuery('.chat_scroll_type').show("slow");
            });
            jQuery("#draggable").draggable();
        });

        function showhideTimer()
        {
            var txt = document.getElementById('disp');
            var lnkShowTimer = document.getElementById('<%= lnkShowTimer.ClientID %>');
            var imgShowTimer = document.getElementById('imgShowTimer');

            if (txt.style.display == 'block') {
                imgShowTimer.src = 'images/hideTimer_icon.png';
                txt.style.display = 'none';
                //lnkShowTimer.innerHTML = 'Show Timer';
            }
            else {
                imgShowTimer.src = 'images/showTimer_icon.png';
                txt.style.display = 'block';
                //lnkShowTimer.innerHTML = 'Hide Timer';
            }
        }

        var showVideoForPublisher = true;
        function showhideVideoForPublisher(lnkId)
        {
            var imgShowVideo = document.getElementById('imgShowVideo');
            if (showVideoForPublisher) {
                // document.getElementById(lnkId).innerHTML = 'Show Video';
                imgShowVideo.src = 'images/hideVideo_icon.png';
                publisher.publishVideo(false);
            }
            else {
                // document.getElementById(lnkId).innerHTML = 'Hide Video';
                imgShowVideo.src = 'images/showVideo_icon.png';
                publisher.publishVideo(true);
            }

            showVideoForPublisher = !showVideoForPublisher;
        }

    </script>
</asp:Content>
