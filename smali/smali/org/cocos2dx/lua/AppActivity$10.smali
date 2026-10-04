.class Lorg/cocos2dx/lua/AppActivity$10;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lua/AppActivity;->payUC(Ljava/lang/String;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$billno:Ljava/lang/String;

.field private final synthetic val$money:I


# direct methods
.method constructor <init>(ILjava/lang/String;)V
    .locals 0

    .prologue
    .line 1
    iput p1, p0, Lorg/cocos2dx/lua/AppActivity$10;->val$money:I

    iput-object p2, p0, Lorg/cocos2dx/lua/AppActivity$10;->val$billno:Ljava/lang/String;

    .line 460
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 462
    new-instance v0, Lcn/uc/gamesdk/info/PaymentInfo;

    invoke-direct {v0}, Lcn/uc/gamesdk/info/PaymentInfo;-><init>()V

    .line 466
    .local v0, "pInfo":Lcn/uc/gamesdk/info/PaymentInfo;
    const-string v1, "callback"

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setCustomInfo(Ljava/lang/String;)V

    .line 470
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setServerId(I)V

    .line 472
    const-string v1, "102"

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setRoleId(Ljava/lang/String;)V

    .line 473
    const-string v1, "\u6e38\u620f\u89d2\u8272\u540d"

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setRoleName(Ljava/lang/String;)V

    .line 474
    const-string v1, "12"

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setGrade(Ljava/lang/String;)V

    .line 481
    iget v1, p0, Lorg/cocos2dx/lua/AppActivity$10;->val$money:I

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setAmount(F)V

    .line 483
    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity$10;->val$billno:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/info/PaymentInfo;->setTransactionNumCP(Ljava/lang/String;)V

    .line 486
    :try_start_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v1

    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->access$7()Lorg/cocos2dx/lua/AppActivity;

    move-result-object v2

    .line 487
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->access$8()Lcn/uc/gamesdk/UCCallbackListener;

    move-result-object v3

    .line 486
    invoke-virtual {v1, v2, v0, v3}, Lcn/uc/gamesdk/UCGameSDK;->pay(Landroid/content/Context;Lcn/uc/gamesdk/info/PaymentInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_0

    .line 491
    :goto_0
    return-void

    .line 488
    :catch_0
    move-exception v1

    goto :goto_0
.end method
