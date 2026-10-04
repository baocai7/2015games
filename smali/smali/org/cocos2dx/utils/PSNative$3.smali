.class Lorg/cocos2dx/utils/PSNative$3;
.super Ljava/lang/Object;
.source "PSNative.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSNative;->createAlert(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$defalutButtonTitle:Ljava/lang/String;

.field private final synthetic val$listener:I

.field private final synthetic val$message:Ljava/lang/String;

.field private final synthetic val$title:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/utils/PSNative$3;->val$message:Ljava/lang/String;

    iput-object p2, p0, Lorg/cocos2dx/utils/PSNative$3;->val$title:Ljava/lang/String;

    iput p3, p0, Lorg/cocos2dx/utils/PSNative$3;->val$listener:I

    iput-object p4, p0, Lorg/cocos2dx/utils/PSNative$3;->val$defalutButtonTitle:Ljava/lang/String;

    .line 90
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 93
    new-instance v0, Lorg/cocos2dx/utils/PSDialog;

    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {v0, v1}, Lorg/cocos2dx/utils/PSDialog;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setCancelable(Z)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v0

    .line 94
    iget-object v1, p0, Lorg/cocos2dx/utils/PSNative$3;->val$message:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setMessage(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/utils/PSNative$3;->val$title:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setTitle(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v0

    .line 95
    iget v1, p0, Lorg/cocos2dx/utils/PSNative$3;->val$listener:I

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setLuaListener(I)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v0

    .line 96
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    invoke-virtual {v0, v1}, Lorg/cocos2dx/utils/PSDialog;->setListener(Lorg/cocos2dx/utils/PSDialog$PSDialogListener;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v0

    .line 93
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 98
    iget-object v0, p0, Lorg/cocos2dx/utils/PSNative$3;->val$defalutButtonTitle:Ljava/lang/String;

    invoke-static {v0}, Lorg/cocos2dx/utils/PSNative;->addAlertButton(Ljava/lang/String;)I

    .line 100
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-eqz v0, :cond_0

    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 101
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0, v1}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    .line 102
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->hide()V

    .line 105
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->show()V

    .line 106
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 107
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 108
    return-void
.end method
