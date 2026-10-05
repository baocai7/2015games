.class Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;
.super Ljava/lang/Object;
.source "DYLoginHandlerDayu.java"

# interfaces
.implements Lcom/dygame/dysdk/DYSdkLoginListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYLoginHandlerDayu;->sdkLogin(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;


# direct methods
.method constructor <init>(Lcom/dygame/open/dayu/DYLoginHandlerDayu;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    .prologue
    .line 89
    iput-object p1, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLoginFailed()V
    .locals 2

    .prologue
    .line 115
    const-string v0, ""

    iget-object v1, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    invoke-static {v1}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->access$000(Lcom/dygame/open/dayu/DYLoginHandlerDayu;)I

    move-result v1

    invoke-static {v0, v1}, Lcom/dygame/common/DYLoginMgr;->onLoginFail(Ljava/lang/String;I)V

    .line 116
    iget-object v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    const/4 v1, -0x1

    invoke-static {v0, v1}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->access$002(Lcom/dygame/open/dayu/DYLoginHandlerDayu;I)I

    .line 117
    return-void
.end method

.method public onLoginSuccess(Lcom/dygame/dysdk/DYSdkLoginResult;)V
    .locals 4
    .param p1, "result"    # Lcom/dygame/dysdk/DYSdkLoginResult;

    .prologue
    .line 98
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 100
    .local v1, "jObj":Lorg/json/JSONObject;
    :try_start_0
    const-string v2, "id"

    const-string v3, ""

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 101
    const-string v2, "token"

    invoke-virtual {p1}, Lcom/dygame/dysdk/DYSdkLoginResult;->getToken()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 102
    const-string v2, "name"

    invoke-virtual {p1}, Lcom/dygame/dysdk/DYSdkLoginResult;->getOpenId()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 103
    const-string v2, "param"

    invoke-virtual {p1}, Lcom/dygame/dysdk/DYSdkLoginResult;->getParam()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 109
    :goto_0
    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    invoke-static {v3}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->access$000(Lcom/dygame/open/dayu/DYLoginHandlerDayu;)I

    move-result v3

    invoke-static {v2, v3}, Lcom/dygame/common/DYLoginMgr;->onLoginSucc(Ljava/lang/String;I)V

    .line 110
    iget-object v2, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    const/4 v3, -0x1

    invoke-static {v2, v3}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->access$002(Lcom/dygame/open/dayu/DYLoginHandlerDayu;I)I

    .line 111
    return-void

    .line 104
    :catch_0
    move-exception v0

    .line 106
    .local v0, "e":Lorg/json/JSONException;
    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method

.method public onLogout()V
    .locals 2

    .prologue
    .line 93
    const-string v0, ""

    const/4 v1, -0x1

    invoke-static {v0, v1}, Lcom/dygame/common/DYLoginMgr;->onLogoutSucc(Ljava/lang/String;I)V

    .line 94
    return-void
.end method
