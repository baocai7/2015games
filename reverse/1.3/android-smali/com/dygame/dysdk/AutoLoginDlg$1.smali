.class Lcom/dygame/dysdk/AutoLoginDlg$1;
.super Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;
.source "AutoLoginDlg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/AutoLoginDlg;->tryAutoLogin()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/dysdk/AutoLoginDlg;


# direct methods
.method constructor <init>(Lcom/dygame/dysdk/AutoLoginDlg;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/dysdk/AutoLoginDlg;

    .prologue
    .line 61
    iput-object p1, p0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    invoke-direct {p0}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 17
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 64
    move-object/from16 v0, p0

    iget-object v14, v0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    iget-boolean v14, v14, Lcom/dygame/dysdk/AutoLoginDlg;->mCancel:Z

    if-eqz v14, :cond_0

    .line 124
    :goto_0
    return-void

    .line 68
    :cond_0
    move-object/from16 v0, p1

    iget v14, v0, Landroid/os/Message;->what:I

    if-nez v14, :cond_1

    .line 69
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v14

    sget-object v15, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    const-string v16, ""

    invoke-interface/range {v14 .. v16}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 71
    .local v10, "tName":Ljava/lang/String;
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v14

    sget-object v15, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    const-string v16, ""

    invoke-interface/range {v14 .. v16}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 74
    .local v11, "tPass":Ljava/lang/String;
    sget-object v13, Lcom/dygame/dysdk/DYSDK;->URI_LOGIN:Ljava/lang/String;

    .line 75
    .local v13, "uri":Ljava/lang/String;
    new-instance v4, Ljava/util/HashMap;

    invoke-direct {v4}, Ljava/util/HashMap;-><init>()V

    .line 76
    .local v4, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v14, "username"

    invoke-virtual {v4, v14, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 77
    const-string v14, "password"

    invoke-virtual {v4, v14, v11}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 79
    move-object/from16 v0, p0

    invoke-static {v13, v4, v0}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    goto :goto_0

    .line 84
    .end local v4    # "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v10    # "tName":Ljava/lang/String;
    .end local v11    # "tPass":Ljava/lang/String;
    .end local v13    # "uri":Ljava/lang/String;
    :cond_1
    move-object/from16 v0, p1

    iget v14, v0, Landroid/os/Message;->what:I

    sget v15, Lcom/dygame/dysdk/DYHttpMgr;->ON_RESP_FAIL:I

    if-ne v14, v15, :cond_2

    .line 85
    move-object/from16 v0, p0

    iget-object v14, v0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    invoke-virtual {v14}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v14

    sget v15, Lcom/dygame/dysdk/R$string;->dysdk_network_error:I

    const/16 v16, 0x0

    invoke-static/range {v14 .. v16}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v14

    .line 87
    invoke-virtual {v14}, Landroid/widget/Toast;->show()V

    .line 88
    const/4 v14, 0x0

    const/4 v15, 0x0

    invoke-static {v14, v15}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    goto :goto_0

    .line 93
    :cond_2
    invoke-virtual/range {p0 .. p0}, Lcom/dygame/dysdk/AutoLoginDlg$1;->getRespData()Ljava/lang/String;

    move-result-object v8

    .line 95
    .local v8, "respData":Ljava/lang/String;
    :try_start_0
    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6, v8}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 96
    .local v6, "jObj":Lorg/json/JSONObject;
    const-string v14, "errorCode"

    invoke-virtual {v6, v14}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v2

    .line 97
    .local v2, "errorCode":I
    const-string v14, "errorMsg"

    invoke-virtual {v6, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 98
    .local v3, "errorMsg":Ljava/lang/String;
    if-eqz v2, :cond_4

    .line 99
    move-object/from16 v0, p0

    iget-object v14, v0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    invoke-virtual {v14}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v14

    const/4 v15, 0x0

    invoke-static {v14, v3, v15}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v14

    .line 100
    invoke-virtual {v14}, Landroid/widget/Toast;->show()V

    .line 101
    const/4 v14, 0x0

    const/4 v15, 0x0

    invoke-static {v14, v15}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_0

    .line 118
    .end local v2    # "errorCode":I
    .end local v3    # "errorMsg":Ljava/lang/String;
    .end local v6    # "jObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v1

    .line 119
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 122
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_3
    const/4 v14, 0x0

    const/4 v15, 0x0

    invoke-static {v14, v15}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 123
    move-object/from16 v0, p0

    iget-object v14, v0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    invoke-virtual {v14}, Lcom/dygame/dysdk/AutoLoginDlg;->dismiss()V

    goto/16 :goto_0

    .line 105
    .restart local v2    # "errorCode":I
    .restart local v3    # "errorMsg":Ljava/lang/String;
    .restart local v6    # "jObj":Lorg/json/JSONObject;
    :cond_4
    :try_start_1
    const-string v14, "data"

    invoke-virtual {v6, v14}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    .line 106
    .local v5, "jData":Lorg/json/JSONObject;
    if-eqz v5, :cond_3

    .line 107
    const-string v14, "token"

    invoke-virtual {v5, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 108
    .local v12, "token":Ljava/lang/String;
    const-string v14, "openId"

    invoke-virtual {v5, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 111
    .local v7, "openId":Ljava/lang/String;
    new-instance v9, Lcom/dygame/dysdk/DYSdkLoginResult;

    const-string v14, ""

    invoke-direct {v9, v7, v12, v14}, Lcom/dygame/dysdk/DYSdkLoginResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 113
    .local v9, "ret":Lcom/dygame/dysdk/DYSdkLoginResult;
    const/4 v14, 0x1

    invoke-static {v14, v9}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 115
    move-object/from16 v0, p0

    iget-object v14, v0, Lcom/dygame/dysdk/AutoLoginDlg$1;->this$0:Lcom/dygame/dysdk/AutoLoginDlg;

    invoke-virtual {v14}, Lcom/dygame/dysdk/AutoLoginDlg;->dismiss()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method
