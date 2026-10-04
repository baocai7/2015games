.class Lorg/cocos2dx/lua/AppActivity$8;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->ucSdkShowFloatButton()V
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
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$8;->this$0:Lorg/cocos2dx/lua/AppActivity;

    .line 422
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 8

    .prologue
    .line 426
    :try_start_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$8;->this$0:Lorg/cocos2dx/lua/AppActivity;

    iget-object v1, v1, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    const-wide/high16 v2, 0x4059000000000000L    # 100.0

    const-wide/high16 v4, 0x4049000000000000L    # 50.0

    const/4 v6, 0x1

    invoke-virtual/range {v0 .. v6}, Lcn/uc/gamesdk/UCGameSDK;->showFloatButton(Landroid/app/Activity;DDZ)V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_0

    .line 431
    :goto_0
    return-void

    .line 427
    :catch_0
    move-exception v7

    .line 429
    .local v7, "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    invoke-virtual {v7}, Lcn/uc/gamesdk/UCCallbackListenerNullException;->printStackTrace()V

    goto :goto_0
.end method
