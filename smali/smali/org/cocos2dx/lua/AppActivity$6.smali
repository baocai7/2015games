.class Lorg/cocos2dx/lua/AppActivity$6;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->ucSdkDestoryFloatButton()V
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
    iput-object p1, p0, Lorg/cocos2dx/lua/AppActivity$6;->this$0:Lorg/cocos2dx/lua/AppActivity;

    .line 360
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 363
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$6;->this$0:Lorg/cocos2dx/lua/AppActivity;

    iget-object v1, v1, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/UCGameSDK;->destoryFloatButton(Landroid/app/Activity;)V

    .line 364
    return-void
.end method
