.class Lorg/cocos2dx/lua/AppActivity$7;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->ucSdkCreateFloatButton()V
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
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$7;->this$0:Lorg/cocos2dx/lua/AppActivity;

    .line 388
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 395
    :try_start_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/lua/AppActivity$7;->this$0:Lorg/cocos2dx/lua/AppActivity;

    iget-object v2, v2, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    .line 396
    new-instance v3, Lorg/cocos2dx/lua/AppActivity$7$1;

    invoke-direct {v3, p0}, Lorg/cocos2dx/lua/AppActivity$7$1;-><init>(Lorg/cocos2dx/lua/AppActivity$7;)V

    .line 395
    invoke-virtual {v1, v2, v3}, Lcn/uc/gamesdk/UCGameSDK;->createFloatButton(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lcn/uc/gamesdk/UCFloatButtonCreateException; {:try_start_0 .. :try_end_0} :catch_1

    .line 412
    :goto_0
    return-void

    .line 406
    :catch_0
    move-exception v0

    .line 407
    .local v0, "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    invoke-virtual {v0}, Lcn/uc/gamesdk/UCCallbackListenerNullException;->printStackTrace()V

    goto :goto_0

    .line 408
    .end local v0    # "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    :catch_1
    move-exception v0

    .line 410
    .local v0, "e":Lcn/uc/gamesdk/UCFloatButtonCreateException;
    invoke-virtual {v0}, Lcn/uc/gamesdk/UCFloatButtonCreateException;->printStackTrace()V

    goto :goto_0
.end method
