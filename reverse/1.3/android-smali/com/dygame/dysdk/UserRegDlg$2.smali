.class Lcom/dygame/dysdk/UserRegDlg$2;
.super Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;
.source "UserRegDlg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/UserRegDlg;->onClickRegister()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/dysdk/UserRegDlg;


# direct methods
.method constructor <init>(Lcom/dygame/dysdk/UserRegDlg;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/dysdk/UserRegDlg;

    .prologue
    .line 189
    iput-object p1, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-direct {p0}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 14
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 192
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    const/4 v12, 0x0

    iput-boolean v12, v11, Lcom/dygame/dysdk/UserRegDlg;->mLoading:Z

    .line 194
    iget v11, p1, Landroid/os/Message;->what:I

    sget v12, Lcom/dygame/dysdk/DYHttpMgr;->ON_RESP_FAIL:I

    if-ne v11, v12, :cond_0

    .line 195
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    sget v12, Lcom/dygame/dysdk/R$string;->dysdk_network_error:I

    const/4 v13, 0x0

    invoke-static {v11, v12, v13}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v11

    .line 197
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V

    .line 247
    :goto_0
    return-void

    .line 201
    :cond_0
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserRegDlg$2;->getRespData()Ljava/lang/String;

    move-result-object v8

    .line 204
    .local v8, "respData":Ljava/lang/String;
    :try_start_0
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v8}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 205
    .local v4, "jObj":Lorg/json/JSONObject;
    const-string v11, "errorCode"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v1

    .line 206
    .local v1, "errorCode":I
    const-string v11, "errorMsg"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 207
    .local v2, "errorMsg":Ljava/lang/String;
    if-eqz v1, :cond_2

    .line 208
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    const/4 v12, 0x0

    invoke-static {v11, v2, v12}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v11

    .line 209
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 241
    .end local v1    # "errorCode":I
    .end local v2    # "errorMsg":Ljava/lang/String;
    .end local v4    # "jObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v0

    .line 242
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 245
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_1
    const/4 v11, 0x0

    const/4 v12, 0x0

    invoke-static {v11, v12}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 246
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/UserRegDlg;->dismiss()V

    goto :goto_0

    .line 213
    .restart local v1    # "errorCode":I
    .restart local v2    # "errorMsg":Ljava/lang/String;
    .restart local v4    # "jObj":Lorg/json/JSONObject;
    :cond_2
    :try_start_1
    const-string v11, "data"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    .line 214
    .local v3, "jData":Lorg/json/JSONObject;
    if-eqz v3, :cond_1

    .line 215
    const-string v11, "token"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 216
    .local v10, "token":Ljava/lang/String;
    const-string v11, "name"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 217
    .local v5, "name":Ljava/lang/String;
    const-string v11, "password"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 218
    .local v7, "password":Ljava/lang/String;
    const-string v11, "openId"

    invoke-virtual {v3, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 221
    .local v6, "openId":Ljava/lang/String;
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    .line 222
    invoke-interface {v11, v12, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 223
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 224
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    .line 225
    invoke-interface {v11, v12, v7}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 226
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 227
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    sget-object v12, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    const/4 v13, 0x0

    .line 228
    invoke-interface {v11, v12, v13}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 229
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 231
    new-instance v9, Lcom/dygame/dysdk/DYSdkLoginResult;

    const-string v11, ""

    invoke-direct {v9, v6, v10, v11}, Lcom/dygame/dysdk/DYSdkLoginResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 233
    .local v9, "ret":Lcom/dygame/dysdk/DYSdkLoginResult;
    const/4 v11, 0x1

    invoke-static {v11, v9}, Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 235
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v11

    sget v12, Lcom/dygame/dysdk/R$string;->dysdk_register_ok:I

    const/4 v13, 0x0

    invoke-static {v11, v12, v13}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v11

    .line 237
    invoke-virtual {v11}, Landroid/widget/Toast;->show()V

    .line 238
    iget-object v11, p0, Lcom/dygame/dysdk/UserRegDlg$2;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v11}, Lcom/dygame/dysdk/UserRegDlg;->dismiss()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method
