.class Lcom/dygame/dysdk/LoginInputDlg$3;
.super Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;
.source "LoginInputDlg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/LoginInputDlg;->onClickAccountLogin()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/dysdk/LoginInputDlg;


# direct methods
.method constructor <init>(Lcom/dygame/dysdk/LoginInputDlg;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/dysdk/LoginInputDlg;

    .prologue
    .line 194
    iput-object p1, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-direct {p0}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 14
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 198
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    const/4 v12, 0x0

    iput-boolean v12, v11, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    .line 200
    iget v11, p1, Landroid/os/Message;->what:I

    sget v12, Lcom/dygame/dysdk/DYHttpMgr;->ON_RESP_FAIL:I

    if-ne v11, v12, :cond_0

    .line 201
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/LoginInputDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    sget v12, Lcom/dygame/dysdk/R$string;->dysdk_network_error:I

    const/4 v13, 0x0

    invoke-static {v11, v12, v13}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v11

    .line 203
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V

    .line 253
    :goto_0
    return-void

    .line 207
    :cond_0
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg$3;->getRespData()Ljava/lang/String;

    move-result-object v8

    .line 210
    .local v8, "respData":Ljava/lang/String;
    :try_start_0
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v8}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 211
    .local v4, "jObj":Lorg/json/JSONObject;
    const-string v11, "errorCode"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v1

    .line 212
    .local v1, "errorCode":I
    const-string v11, "errorMsg"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 213
    .local v2, "errorMsg":Ljava/lang/String;
    if-eqz v1, :cond_2

    .line 214
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/LoginInputDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    const/4 v12, 0x0

    invoke-static {v11, v2, v12}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v11

    .line 215
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 247
    .end local v1    # "errorCode":I
    .end local v2    # "errorMsg":Ljava/lang/String;
    .end local v4    # "jObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v0

    .line 248
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 251
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_1
    const/4 v11, 0x0

    const/4 v12, 0x0

    invoke-static {v11, v12}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 252
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/LoginInputDlg;->dismiss()V

    goto :goto_0

    .line 219
    .restart local v1    # "errorCode":I
    .restart local v2    # "errorMsg":Ljava/lang/String;
    .restart local v4    # "jObj":Lorg/json/JSONObject;
    :cond_2
    :try_start_1
    const-string v11, "data"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    .line 220
    .local v3, "jData":Lorg/json/JSONObject;
    if-eqz v3, :cond_1

    .line 221
    const-string v11, "token"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 222
    .local v10, "token":Ljava/lang/String;
    const-string v11, "name"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 223
    .local v5, "name":Ljava/lang/String;
    const-string v11, "password"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 224
    .local v7, "password":Ljava/lang/String;
    const-string v11, "openId"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 227
    .local v6, "openId":Ljava/lang/String;
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    .line 228
    invoke-interface {v11, v12, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 229
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 230
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    .line 231
    invoke-interface {v11, v12, v7}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 232
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 233
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    const/4 v13, 0x0

    .line 234
    invoke-interface {v11, v12, v13}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 235
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 237
    new-instance v9, Lcom/dygame/dysdk/DYSdkLoginResult;

    const-string v11, ""

    invoke-direct {v9, v6, v10, v11}, Lcom/dygame/dysdk/DYSdkLoginResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 239
    .local v9, "ret":Lcom/dygame/dysdk/DYSdkLoginResult;
    const/4 v11, 0x1

    invoke-static {v11, v9}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 241
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/LoginInputDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    sget v12, Lcom/dygame/dysdk/R$string;->dysdk_login_ok:I

    const/4 v13, 0x0

    invoke-static {v11, v12, v13}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v11

    .line 243
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V

    .line 244
    iget-object v11, p0, Lcom/dygame/dysdk/LoginInputDlg$3;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/LoginInputDlg;->dismiss()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method
