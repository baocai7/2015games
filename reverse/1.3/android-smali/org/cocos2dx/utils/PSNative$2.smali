.class final Lorg/cocos2dx/utils/PSNative$2;
.super Ljava/lang/Object;
.source "PSNative.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSNative;->createAlert(Ljava/lang/String;Ljava/lang/String;Ljava/util/Vector;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$buttonTitles:Ljava/util/Vector;

.field final synthetic val$listener:I

.field final synthetic val$message:Ljava/lang/String;

.field final synthetic val$title:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;ILjava/util/Vector;)V
    .locals 0

    .prologue
    .line 56
    iput-object p1, p0, Lorg/cocos2dx/utils/PSNative$2;->val$message:Ljava/lang/String;

    iput-object p2, p0, Lorg/cocos2dx/utils/PSNative$2;->val$title:Ljava/lang/String;

    iput p3, p0, Lorg/cocos2dx/utils/PSNative$2;->val$listener:I

    iput-object p4, p0, Lorg/cocos2dx/utils/PSNative$2;->val$buttonTitles:Ljava/util/Vector;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .prologue
    .line 59
    new-instance v1, Lorg/cocos2dx/utils/PSDialog;

    sget-object v2, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {v1, v2}, Lorg/cocos2dx/utils/PSDialog;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setCancelable(Z)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/utils/PSNative$2;->val$message:Ljava/lang/String;

    .line 60
    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setMessage(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/utils/PSNative$2;->val$title:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setTitle(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/utils/PSNative$2;->val$listener:I

    .line 61
    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setLuaListener(I)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    sget-object v2, Lorg/cocos2dx/utils/PSNative;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    .line 62
    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setListener(Lorg/cocos2dx/utils/PSDialog$PSDialogListener;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    sget-object v2, Lorg/cocos2dx/utils/PSNative;->mAppIcon:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1, v2}, Lorg/cocos2dx/utils/PSDialog;->setIcon(Landroid/graphics/drawable/Drawable;)Lorg/cocos2dx/utils/PSDialog;

    move-result-object v1

    sput-object v1, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 64
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Lorg/cocos2dx/utils/PSNative$2;->val$buttonTitles:Ljava/util/Vector;

    invoke-virtual {v1}, Ljava/util/Vector;->size()I

    move-result v1

    if-ge v0, v1, :cond_0

    .line 65
    iget-object v1, p0, Lorg/cocos2dx/utils/PSNative$2;->val$buttonTitles:Ljava/util/Vector;

    invoke-virtual {v1, v0}, Ljava/util/Vector;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-static {v1}, Lorg/cocos2dx/utils/PSNative;->addAlertButton(Ljava/lang/String;)I

    .line 64
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 68
    :cond_0
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-eqz v1, :cond_1

    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v1}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 69
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    sget-object v2, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v1, v2}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    .line 70
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v1}, Lorg/cocos2dx/utils/PSDialog;->hide()V

    .line 73
    :cond_1
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v1}, Lorg/cocos2dx/utils/PSDialog;->show()V

    .line 74
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    sput-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 75
    const/4 v1, 0x0

    sput-object v1, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 76
    return-void
.end method
