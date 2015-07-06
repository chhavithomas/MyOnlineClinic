using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using myonline.Biz.ADM;
using myonline.Framework.Util;
using System.Data;
using System.Text;
using System.Web.Services;

namespace OlineClinic
{
    public partial class LiveChat : System.Web.UI.Page
    {
        #region "VARIABLES"
        public string sessionId = string.Empty;
        public string token = string.Empty;
        public string PatientId = string.Empty;
        public string DoctorId = string.Empty;
        public string AppointMentId = string.Empty;
        protected int intUserType = 0;

        OpenTokSDK opentok = new OpenTokSDK();
        static DataTable dtAppointmentList = new DataTable(); 
        #endregion

        #region "PAGE EVENTS"
        //Checking User Session If Session Is Not Available Sending User To Login Page 
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (Convert.ToString(Session["USER_SEQ"]) == "" && Session["USER_SEQ"] == null)
            {
                Response.Redirect(ResolveUrl("doctor_login.aspx"));
            }
        }

        //Calling Function For Video Chat
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["dtAppointmentList"] != null) //For Doctor
                {
                    dtAppointmentList = Session["dtAppointmentList"] as DataTable;
                    lnkShowVideo.Attributes.Add("onclick", "showhideVideoForPublisher('" + lnkShowVideo.ClientID + "');");
                }
                else //For Patient
                {
                    lnkShowVideo.Attributes.Add("onclick", "showhideVideoForPublisher('" + lnkShowVideo.ClientID + "');");
                    HiddenField1.Value = "AbCD";
                }
                if (!IsPostBack)
                {
                    if (Session["UserType"] != null)
                    {
                        intUserType = Convert.ToInt32(Session["UserType"]);
                        hdnUserType.Value = intUserType.ToString();
                    }

                    if (intUserType == 1)
                    {
                        HiddenField1.Value = "Patient";
                    }

                    lnkDisconnect.Visible = false;
                    lnkDisconnect1.Visible = false;
                    VidoeChat();
                    GetUser();
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.InnerException);
            }
        } 
        #endregion

        #region "CONTROLS EVENTS"
        //lnkDisconnect1 LinkButton Click Event - To Disconnect The Video Chat Temprarly Means Doctor Disconnect Chat and 
        protected void lnkDisconnect1_ServerClick(object sender, EventArgs e)
        {
            string ReturnStatusMsg = "";
            Hashtable htSearch = new Hashtable();
            DataSet dataSet = new DataSet();

            VideoChat objchat = new VideoChat();
            htSearch.Clear();
            htSearch.Add("flag", 10);
            htSearch.Add("AppointMentIds", Convert.ToInt32(AppontMentId.Value));

            dataSet = objchat.UpdateAppointmentStatus(htSearch, ref ReturnStatusMsg);

            if (dataSet.Tables[0].Rows.Count > 0)
            {
                Response.Redirect("doctorfutureconsults.aspx");
            }
        } 
        #endregion

        #region "USER DEFINED FUNCTIONS"
        //Connecting Video Chat for Both(patient and Doctor)
        public void VidoeChat()
        {
            lblPatientMobileNo.Text = string.Empty;
            if (Request.QueryString["session"] != null)
            {
                //sessionId = Request.QueryString["session"].ToString();
                //token = opentok.GenerateToken(sessionId);
                hdsession.Value = Request.QueryString["session"].ToString();
                hdtoken.Value = opentok.GenerateToken(hdsession.Value);

                try
                {
                    Hashtable htSearch = new Hashtable();
                    DataSet dsList = new DataSet();
                    myonline.Biz.ADM.VideoChat objBiz = null;
                    objBiz = new myonline.Biz.ADM.VideoChat();
                    htSearch.Add("flag", 7);
                    htSearch.Add("Session", hdsession.Value);
                    if (System.Web.HttpContext.Current.Session["TimeZone"] != null && Convert.ToString(Session["TimeZone"]) != "-")
                    {
                        htSearch.Add("Time", System.Web.HttpContext.Current.Session["TimeZone"]);
                    }
                    else
                    {
                        htSearch.Add("Time", "+5:30");
                    }
                    dsList = objBiz.GetTrainerAndTranieeName(htSearch);
                    if (dsList.Tables["ERR_TABLE"] == null || dsList.Tables["ERR_TABLE"].Rows.Count == 0)
                    {
                        string session_id = hdsession.Value;
                        string token_id = hdtoken.Value;
                        if (dsList.Tables[0] != null && dsList.Tables[0].Rows.Count > 0)
                        {
                            if (dsList.Tables[0].Rows[0][0].ToString() != "0")
                            {

                                //lbltrainer.Text = dsList.Tables[0].Rows[0]["DoctorName"].ToString();
                                //lbltrainee.Text = dsList.Tables[0].Rows[0]["PatientName"].ToString();

                                lbltrainer.Text = dsList.Tables[0].Rows[0]["PatientName"].ToString().ToLower();
                                lbltrainee.Text = dsList.Tables[0].Rows[0]["DoctorName"].ToString().ToLower();

                                hdnPatientName.Value = dsList.Tables[0].Rows[0]["PatientName"].ToString().ToLower(); 
                                PatientId = dsList.Tables[0].Rows[0][2].ToString();
                                DoctorId = dsList.Tables[0].Rows[0][3].ToString();
                                AppointMentId = dsList.Tables[0].Rows[0][4].ToString();
                                AppontMentId.Value = AppointMentId;
                            }
                            else
                            {
                                Response.Redirect(ResolveUrl("DoctorVideoChat.aspx?Request=false"));
                            }
                        }
                        else if (dsList.Tables[0] == null || dsList.Tables[0].Rows.Count == 0)
                        {

                        }
                    }
                }
                catch (Exception ex)
                { Response.Write(ex.InnerException); }
                //Gettime();
                //Page.ClientScript.RegisterStartupScript(Page.GetType(), "onload", "StartVideo();", true);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "onload", "StartVideo();", true);
            }
            else
            {
                string msg = string.Empty;
                string sessionId = string.Empty;
                string token = string.Empty;
                OpenTokSDK opentok = new OpenTokSDK();
                Hashtable htSearch = new Hashtable();
                DataSet dsList = new DataSet();
                string ReturnStatusMsg = string.Empty;
                string sTransMsg = String.Empty;
                try
                {

                    //sessionId = opentok.CreateSession("Global-Training");
                    //token = opentok.GenerateToken(sessionId);
                    string abcdsession = opentok.CreateSession("Global-Training");
                    string abcdtoken = opentok.GenerateToken(abcdsession);

                    hdsession.Value = abcdsession;
                    hdtoken.Value = abcdtoken;

                    myonline.Biz.ADM.VideoChat objBiz = null;
                    objBiz = new myonline.Biz.ADM.VideoChat();
                    htSearch.Clear();
                    htSearch.Add("flag", 2);
                    htSearch.Add("doctorId", HttpContext.Current.Session["USER_SEQ"]);
                    htSearch.Add("Chat_Status", "Pending");
                    htSearch.Add("AppointMentId", Request.QueryString["AppointMentId"]);

                    htSearch.Add("Session_Id", hdsession.Value);
                    htSearch.Add("Generate_Date", DateTime.UtcNow.ToString());
                    htSearch.Add("Expire_Date", DateTime.UtcNow.AddMinutes(15));
                    if (System.Web.HttpContext.Current.Session["TimeZone"] != null && Convert.ToString(Session["TimeZone"]) != "-")
                    {
                        htSearch.Add("Time", System.Web.HttpContext.Current.Session["TimeZone"]);
                    }
                    else
                    {
                        htSearch.Add("Time", "+5:30");
                    }
                    dsList = objBiz.Send_request(htSearch, ref ReturnStatusMsg);

                    if (dsList.Tables["ERR_TABLE"] == null || dsList.Tables["ERR_TABLE"].Rows.Count == 0)
                    {
                        string session_id = hdsession.Value;
                        string token_id = hdtoken.Value;
                        if (dsList.Tables[0] != null && dsList.Tables[0].Rows.Count > 0)
                        {
                            if (dsList.Tables[0].Rows[0][0].ToString() != "0")
                            {
                                AppontMentId.Value = dsList.Tables[0].Rows[0][1].ToString();
                                lbltrainer.Text = dsList.Tables[0].Rows[0]["DoctorName"].ToString().ToLower();
                                lbltrainee.Text = dsList.Tables[0].Rows[0]["PatientName"].ToString().ToLower();
                                hdnDoctorName.Value = dsList.Tables[0].Rows[0]["DoctorName"].ToString().ToLower(); 
                                DoctorId = dsList.Tables[0].Rows[0][4].ToString();
                                PatientId = dsList.Tables[0].Rows[0][5].ToString();
                                AppointMentId = dsList.Tables[0].Rows[0][1].ToString();
                                lblPatientMobileNo.Text = dsList.Tables[0].Rows[0]["MobileNumber"].ToString();

                                //Page.ClientScript.RegisterStartupScript(Page.GetType(), "onload", "StartVideo();", true);

                                ScriptManager.RegisterStartupScript(this, this.GetType(), "onload", "StartVideo();", true);
                            }
                            else
                            {
                                Response.Redirect(ResolveUrl("DoctorVideoChat.aspx?Request=false"));
                            }
                        }
                        else if (dsList.Tables[0] == null || dsList.Tables[0].Rows.Count == 0)
                        {

                        }
                    }
                    else if (dsList.Tables["ERR_TABLE"] != null && dsList.Tables["ERR_TABLE"].Rows.Count != 0)
                    { }
                }
                catch (Exception ex)
                {
                    throw ex;

                }
            }
        }

        //Hiding and Showing Button(EndConsult,Discoonect button) 
        public void GetUser()
        {
            try
            {
                myonline.Biz.ADM.VideoChat objBiz = null;
                objBiz = new myonline.Biz.ADM.VideoChat();
                Hashtable htSearch = new Hashtable();
                DataSet dsList = new DataSet();
                htSearch.Add("flag", 6);
                htSearch.Add("user_seq", Session["USER_SEQ"]);
                if (System.Web.HttpContext.Current.Session["TimeZone"] != null && Convert.ToString(Session["TimeZone"]) != "-")
                {
                    htSearch.Add("Time", System.Web.HttpContext.Current.Session["TimeZone"]);
                }
                else
                {
                    htSearch.Add("Time", "+5:30");
                }
                dsList = objBiz.GetUser(htSearch);

                if (dsList.Tables["ERR_TABLE"] == null || dsList.Tables["ERR_TABLE"].Rows.Count == 0)
                {
                    if (dsList.Tables[0].Rows[0][0].ToString() == "Doctor")
                    {
                        link.NavigateUrl = "doctor_dashboard.aspx";
                        lbPatient.Visible = true;

                        //TODO: uncomment to visible end consult button 
                        //lnkDisconnect.Visible = true;
                        lnkDisconnect1.Visible = true;
                        lbPatient.HRef = "ClinicalDashBoard.aspx?appId=" + AppointMentId + "&patId=" + PatientId;
                    }
                    else
                    {
                        link.NavigateUrl = "patient_dashboard.aspx";

                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.InnerException);
            }
        }

        //Manage Next Appointment when consult time cross 15 min
        public static bool UpdateNextAppointment(string duration)
        {
            bool success = true;
            int chatValidTime = 15;

            try
            {
                if (dtAppointmentList.Rows.Count > 1)
                {
                    DataTable dt = dtAppointmentList;
                    string[] arrDuration = duration.Split(':');

                    double totalMin = 0;

                    int hours = 0;
                    int minutes = 0;

                    if (arrDuration.Length > 0)
                    {
                        int.TryParse(arrDuration[0], out hours);
                    }
                    if (arrDuration.Length > 1)
                    {
                        int.TryParse(arrDuration[1], out minutes);
                    }

                    TimeSpan tsHour = TimeSpan.FromHours(hours);
                    TimeSpan tsMin = TimeSpan.FromMinutes(minutes);

                    totalMin = tsHour.TotalMinutes + tsMin.TotalMinutes;

                    if (totalMin > 0)
                    {
                        int nextAppoiintmenDuration = Convert.ToInt32(dt.Rows[0]["NextAppoiintmenDuration"]);

                        if (nextAppoiintmenDuration > 0)
                        {
                            totalMin = totalMin + (chatValidTime - nextAppoiintmenDuration);
                        }

                        Hashtable htSearch = new Hashtable();
                        DataSet dsList = new DataSet();
                        myonline.Biz.ADM.VideoChat objBiz = new myonline.Biz.ADM.VideoChat();

                        htSearch.Clear();
                        htSearch.Add("flag", 9);

                        if (totalMin >= 30 && dt.Rows.Count > 1)
                        {
                            htSearch.Add("AppointMentId", Convert.ToString(dt.Rows[1]["id"]));
                            htSearch.Add("Status", 7); //Status - 7 for Approved -Not Completed
                            dsList = objBiz.GetPatient(htSearch);
                        }
                        else if (totalMin > 15 && dt.Rows.Count > 1)
                        {
                            htSearch.Add("AppointMentId", Convert.ToString(dt.Rows[1]["id"]));
                            int extraMin = (int)(totalMin - chatValidTime);
                            DateTime dtModifiedAppointmentDate = Convert.ToDateTime(dt.Rows[1]["appointdate"]);
                            dtModifiedAppointmentDate = dtModifiedAppointmentDate.AddMinutes(extraMin);
                            htSearch.Add("ModifiedAppointmentDate", dtModifiedAppointmentDate);
                            dsList = objBiz.GetPatient(htSearch);
                        }
                    }
                }
            }
            catch
            {
                success = false;
            }
            return success;

        }

        //End Video Chat By Doctor Parmenatly Means Consult is Over
        [WebMethod]
        public static string VideoSessionClose(string Id, string duration)
        {
            Hashtable htSearch = new Hashtable();
            DataSet dsList = new DataSet();

            double totalMin = 0;

            int hours = 0;
            int minutes = 0;
            string[] arrDuration = duration.Split(':');

            if (arrDuration != null && arrDuration.Length > 0)
            {
                if (arrDuration.Length > 0)
                {
                    int.TryParse(arrDuration[0], out hours);
                }
                if (arrDuration.Length > 1)
                {
                    int.TryParse(arrDuration[1], out minutes);
                }

                TimeSpan tsHour = TimeSpan.FromHours(hours);
                TimeSpan tsMin = TimeSpan.FromMinutes(minutes);

                totalMin = tsHour.TotalMinutes + tsMin.TotalMinutes;
            }
            try
            {
                htSearch.Add("flag", 5);
                htSearch.Add("AppointMentId", Id);
                htSearch.Add("Duration", totalMin);
                myonline.Biz.ADM.VideoChat objBiz = null;

                if (System.Web.HttpContext.Current.Session["TimeZone"] != null && Convert.ToString(HttpContext.Current.Session["TimeZone"]) != "-")
                {
                    htSearch.Add("Time", System.Web.HttpContext.Current.Session["TimeZone"]);
                }
                else
                {
                    htSearch.Add("Time", "+5:30");
                }
                objBiz = new myonline.Biz.ADM.VideoChat();
                dsList = objBiz.GetPatient(htSearch);

                if (dsList.Tables["ERR_TABLE"] == null || dsList.Tables["ERR_TABLE"].Rows.Count == 0)
                {
                    UpdateNextAppointment(duration);

                    if (dsList.Tables[0] != null && dsList.Tables[0].Rows.Count > 0)
                    {
                        if (dsList.Tables[0].Rows[0][0].ToString() != "0")
                        {
                            if (dtAppointmentList != null && dtAppointmentList.Rows.Count > 0)
                            {
                                return "1";
                            }
                        }
                        else
                        {

                        }
                    }
                    else if (dsList.Tables[0] == null || dsList.Tables[0].Rows.Count == 0)
                    {

                    }
                }
                else if (dsList.Tables["ERR_TABLE"] != null && dsList.Tables["ERR_TABLE"].Rows.Count != 0)
                {

                }
            }
            catch (Exception ex)
            {
                return "";
            }
            return "";
        } 
        #endregion
    }
}
