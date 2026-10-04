.class public Lcn/uc/gamesdk/a/b;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field public static final a:I = 0x1

.field public static final b:I = 0x2

.field private static final c:J = 0x7db16a17a839a015L


# instance fields
.field private d:Ljava/lang/String;

.field private e:Ljava/lang/String;

.field private f:I

.field private g:Z

.field private h:Z

.field private i:Ljava/lang/String;

.field private j:I

.field private k:I


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    iput v0, p0, Lcn/uc/gamesdk/a/b;->j:I

    return-void
.end method


# virtual methods
.method public a()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/a/b;->k:I

    return v0
.end method

.method public a(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/a/b;->k:I

    return-void
.end method

.method public a(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/a/b;->d:Ljava/lang/String;

    return-void
.end method

.method public a(Z)V
    .locals 0

    iput-boolean p1, p0, Lcn/uc/gamesdk/a/b;->g:Z

    return-void
.end method

.method public b()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/a/b;->j:I

    return v0
.end method

.method public b(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/a/b;->j:I

    return-void
.end method

.method public b(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/a/b;->e:Ljava/lang/String;

    return-void
.end method

.method public b(Z)V
    .locals 0

    iput-boolean p1, p0, Lcn/uc/gamesdk/a/b;->h:Z

    return-void
.end method

.method public c(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/a/b;->f:I

    return-void
.end method

.method public c(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/a/b;->i:Ljava/lang/String;

    return-void
.end method

.method public c()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/a/b;->g:Z

    return v0
.end method

.method public d()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/a/b;->d:Ljava/lang/String;

    return-object v0
.end method

.method public e()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/a/b;->e:Ljava/lang/String;

    return-object v0
.end method

.method public f()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/a/b;->f:I

    return v0
.end method

.method public g()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/gamesdk/a/b;->h:Z

    return v0
.end method

.method public h()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/a/b;->i:Ljava/lang/String;

    return-object v0
.end method
