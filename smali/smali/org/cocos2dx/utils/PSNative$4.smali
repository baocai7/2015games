.class Lorg/cocos2dx/utils/PSNative$4;
.super Ljava/lang/Object;
.source "PSNative.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSNative;->showAlert()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 124
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1
    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 127
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-eqz v0, :cond_0

    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 128
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0, v1}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    .line 129
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->hide()V

    .line 132
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->show()V

    .line 133
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 134
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 135
    return-void
.end method
