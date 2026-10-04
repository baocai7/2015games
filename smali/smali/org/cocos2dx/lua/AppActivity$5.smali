.class Lorg/cocos2dx/lua/AppActivity$5;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->ucSdkLogin()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lua/AppActivity;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$5;->this$0:Lorg/cocos2dx/lua/AppActivity;

    .line 258
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$0(Lorg/cocos2dx/lua/AppActivity$5;)Lorg/cocos2dx/lua/AppActivity;
    .locals 1

    .prologue
    .line 258
    iget-object v0, p0, Lorg/cocos2dx/lua/AppActivity$5;->this$0:Lorg/cocos2dx/lua/AppActivity;

    return-object v0
.end method


# virtual methods
.method public run()V
    .locals 7

    .prologue
    .line 261
    const/4 v1, 0x0

    .line 262
    .local v1, "gameAccountEnable":Z
    :try_start_0
    const-string v2, "\u9017\u6bd4\u563b\u6e38"

    .line 265
    .local v2, "gameAccountTitle":Ljava/lang/String;
    new-instance v4, Lorg/cocos2dx/lua/AppActivity$5$1;

    invoke-direct {v4, p0}, Lorg/cocos2dx/lua/AppActivity$5$1;-><init>(Lorg/cocos2dx/lua/AppActivity$5;)V

    .line 300
    .local v4, "loginCallbackListener":Lcn/uc/gamesdk/UCCallbackListener;, "Lcn/uc/gamesdk/UCCallbackListener<Ljava/lang/String;>;"
    if-eqz v1, :cond_0

    .line 302
    new-instance v3, Lorg/cocos2dx/lua/AppActivity$5$2;

    invoke-direct {v3, p0}, Lorg/cocos2dx/lua/AppActivity$5$2;-><init>(Lorg/cocos2dx/lua/AppActivity$5;)V

    .line 324
    .local v3, "gameUserLoginHook":Lcn/uc/gamesdk/IGameUserLogin;
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v5

    iget-object v6, p0, Lorg/cocos2dx/lua/AppActivity$5;->this$0:Lorg/cocos2dx/lua/AppActivity;

    iget-object v6, v6, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v5, v6, v4, v3, v2}, Lcn/uc/gamesdk/UCGameSDK;->login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;Lcn/uc/gamesdk/IGameUserLogin;Ljava/lang/String;)V

    .line 334
    .end local v2    # "gameAccountTitle":Ljava/lang/String;
    .end local v3    # "gameUserLoginHook":Lcn/uc/gamesdk/IGameUserLogin;
    .end local v4    # "loginCallbackListener":Lcn/uc/gamesdk/UCCallbackListener;, "Lcn/uc/gamesdk/UCCallbackListener<Ljava/lang/String;>;"
    :goto_0
    return-void

    .line 329
    .restart local v2    # "gameAccountTitle":Ljava/lang/String;
    .restart local v4    # "loginCallbackListener":Lcn/uc/gamesdk/UCCallbackListener;, "Lcn/uc/gamesdk/UCCallbackListener<Ljava/lang/String;>;"
    :cond_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v5

    iget-object v6, p0, Lorg/cocos2dx/lua/AppActivity$5;->this$0:Lorg/cocos2dx/lua/AppActivity;

    iget-object v6, v6, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v5, v6, v4}, Lcn/uc/gamesdk/UCGameSDK;->login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 331
    .end local v2    # "gameAccountTitle":Ljava/lang/String;
    .end local v4    # "loginCallbackListener":Lcn/uc/gamesdk/UCCallbackListener;, "Lcn/uc/gamesdk/UCCallbackListener<Ljava/lang/String;>;"
    :catch_0
    move-exception v0

    .line 332
    .local v0, "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    invoke-virtual {v0}, Lcn/uc/gamesdk/UCCallbackListenerNullException;->printStackTrace()V

    goto :goto_0
.end method
